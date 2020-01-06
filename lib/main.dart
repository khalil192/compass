import 'package:flutter/material.dart';
import 'controller.dart';
import 'mazeSolver.dart';
import 'package:flutter/rendering.dart';


//git push origin --set-upstream gh-pages
void main() => runApp(MyApp());

String searchMethod = "dfs";

String currentSelection = "block";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'path finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int perRow = 30;
  static int numCells = 600;
  ValueController valueController =  ValueController(numCells,perRow);
   void solveMaze(){
    MazeSolver mazeSolver  = new MazeSolver(valueController);
    mazeSolver.fillCells();
    switch(searchMethod){
      case "dfs" :{
        mazeSolver.dfs(0, 587);
      }
      break;
      case "bfs" :{
        mazeSolver.bfs(0, 587);
      }
      break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('path finder'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    value: searchMethod,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                    color: Colors.deepPurple
                      ),
                      onChanged: (String newValue) {
                                setState(() {
                                  searchMethod = newValue;
                                });
                          },
                          items: <String>['dfs' , 'bfs']
                          .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                          }
                  ).toList(),
                  ),
                   DropdownButton<String>(
                    value: currentSelection,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                    color: Colors.deepPurple
                      ),
                      onChanged: (String newValue) {
                                setState(() {
                                  currentSelection = newValue;
                                });
                          },
                          items: <String>['start','block','end']
                          .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                          }
                  ).toList(),
                  ),
                
                ],
              )
            ],
          ),
          body: Center(child: Grid(valueController)), 
           floatingActionButton: FloatingActionButton(
            onPressed: ()=>{
                solveMaze(),
            },
          )
    );
  }
}

class Grid extends StatefulWidget {
  final ValueController valueController;
  Grid(this.valueController);
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
final Set<int> selectedIndexes = Set<int>();
  final key = GlobalKey();
  final Set<_Foo> _trackTaped = Set<_Foo>();

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext.findRenderObject();
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _Foo && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }
  int lastStartSelected = 0;
  int prevStartSelected = 0;
  int lastEndSelected = 230;
  int prevEndSelected = 230;
  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
      lastStartSelected = index;
      lastEndSelected = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(selectedIndexes);
    print(currentSelection);
    for(int index in selectedIndexes){
      if(currentSelection == 'block'){
      widget.valueController.selectIndex(index); 
      }
      if(currentSelection == 'start'){
        if(prevEndSelected == lastStartSelected){
            if(prevEndSelected% widget.valueController.perRow > 0){
              lastStartSelected -=1;
            }else{
              lastStartSelected +=1;
            }
        }
        widget.valueController.cellController[prevStartSelected].selectedAs.value = "normal";
        prevStartSelected = lastStartSelected;
      }
      if(currentSelection == 'end'){
        if(prevStartSelected == lastEndSelected){
            if(prevStartSelected% widget.valueController.perRow > 0){
              lastEndSelected -=1;
            }else{
              lastEndSelected +=1;
            }
        }
        widget.valueController.cellController[prevEndSelected].selectedAs.value = "normal";
        prevEndSelected = lastEndSelected;
      }
    }
    widget.valueController.cellController[prevStartSelected].selectedAs.value = "start";
    widget.valueController.cellController[prevEndSelected].selectedAs.value = "end";
    return Container(
      width: 900,
      height: 900,
      child: Listener(
        onPointerDown: _detectTapedItem,
        onPointerMove: _detectTapedItem,
        onPointerUp: _clearSelection,
        child: GridView.builder(
          key: key,
          itemCount: widget.valueController.numCells,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.valueController.perRow, // change this value
            childAspectRatio: 1.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) {
            return Foo(
              index: index,
              child: Cell(widget.valueController.cellController[index]),
            );
          },
        ),
      ),
    );
  }

  void _clearSelection(PointerUpEvent event) {
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
    });
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  Foo({Widget child, this.index, Key key}) : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject..index = index;
  }
}

class _Foo extends RenderProxyBox {
  int index;
}


class Cell extends StatefulWidget {
  CellController cellController;
  Cell(this.cellController);
  @override
  _CellState createState() => _CellState();
}

Color getColor(String selectedAs){
    if(selectedAs == "block"){
      return Colors.blue;
    }
    return Colors.white;
}
int startSelection = -1;
class _CellState extends State<Cell> {
  void cellClicked() async{
  currentSelection =  widget.cellController.selectedAs.value;
  switch(currentSelection){
    case "normal":{
      currentSelection = "block";
      widget.cellController.selectedAs.value = currentSelection;
    }
    break;
    case "block":{
      currentSelection = "normal";
      widget.cellController.selectedAs.value = currentSelection;
    }
    break;
  }  
  }
  void updateCurrSelection(){
  //   String nowSelection =  widget.cellController.selectedAs.value;
  // switch (currentSelection){
  //   case "normal":{
  //     currentSelection = "block";
  //   }
  //   break;
  // }
  // switch(nowSelection){
  //   case "normal":{
  //     currentSelection = "block";
  //   }
  //   break;
  // }  
  }
  void updateStartSelection(){
    print(widget.cellController.index.toString() + " this is dragged");
    currentSelection =  widget.cellController.selectedAs.value;
  switch(currentSelection){
    case "normal":{
      currentSelection = "block";
    }
    break;
    case "block":{
      currentSelection = "normal";
    }
    break;
  }  
  }
  void updateStopSelection(){
    switch(currentSelection){
    case "start":{
      currentSelection = "block";
    }
    break;
    case "end":{
      currentSelection = "block";
    }
    break;
  } 
  }
  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: widget.cellController.length,
      builder: (context,cellLength,child){
        return GestureDetector(
          onTap: ()=>{            
            cellClicked(),
          },
          onVerticalDragStart: (details){
            updateStartSelection();
          },
          onVerticalDragUpdate: (details){
            updateCurrSelection();
          },
          onVerticalDragEnd: (details){
            updateStopSelection();
          },
          onHorizontalDragStart: (details){
            updateStartSelection();
          },
          onHorizontalDragUpdate: (details){
            updateCurrSelection();
          },
          onHorizontalDragEnd: (details){
            updateStopSelection();
          },
          child: ValueListenableBuilder(
            valueListenable: widget.cellController.selectedAs,
            builder: (context, selectedAs, child){
                return AnimatedContainer(
                  duration: Duration(milliseconds: 50),
                  width: cellLength,
                  height: cellLength,
                  decoration: BoxDecoration(
                 border: Border.all(color: Colors.blue[200]),
                  color: getColor(widget.cellController.selectedAs.value), 
                   ),
                  child: widget.cellController.getWidget(),
                );
            },
          ),
        );
      },
    );
  
  }
}

