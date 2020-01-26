import 'package:flutter/material.dart';
import 'controller.dart';
import 'mazeSolver.dart';
import 'package:flutter/rendering.dart';
import 'recursiveDivision.dart';
//flutter pub global activate peanut
//flutter pub get
//git push origin --set-upstream gh-pages
void main() => runApp(MyApp());

String searchMethod = "Depth First Search";

String currentSelection = "block";
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'path finder',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}
// ValueController valueController;
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
  
class _HomeScreenState extends State<HomeScreen> {
  static int perRow = 30;
  static int numCells = 900;
  ValueController valueController =  ValueController(numCells,perRow);
   void solveMaze(){
    MazeSolver mazeSolver  = new MazeSolver(valueController);
    mazeSolver.fillCells();
    mazeSolver.findPath(searchMethod);
    
  }
  void createMaze(){
    RecursiveDivision recursiveDivision = new RecursiveDivision(valueController);
    recursiveDivision.doRecursiveDivide();
  }
  void clearAll(){
    setState(() {
      valueController = new ValueController(numCells, perRow);
    });
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Text("size of grid"),),
                      SliderTheme(
                        data:SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor:Colors.grey,
                          thumbColor: Colors.black,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        ),
                        child: Slider(
                              min: 20.0,
                              max: 100,
                              value: perRow.toDouble(),
                                  onChanged: (newRating){
                                    setState(() {
                                      perRow = newRating.toInt();
                                      numCells = perRow * 30; 
                                      valueController = new ValueController(numCells, perRow);
                                    });
                                },
                          ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side : BorderSide(color: Colors.white)
                    ),
                    onPressed: ()=>{
                      createMaze(),
                    },
                      child: Text("create Maze"),
                  ),
                  SizedBox(width: 10,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side : BorderSide(color: Colors.white)
                    ),
                    onPressed: ()=>{
                      clearAll(),
                    },
                      child: Text("clear all blocks"),
                  ),
                  SizedBox(width: 10,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side : BorderSide(color: Colors.white)
                    ),
                    // color: Colors.green[400],
                      child: Container(
                        child: Text('Random Maze'),
                      ),
                      onPressed:()=> {valueController.createRandomMaze()},
                  )
                  ,
                  SizedBox(width: 10,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side : BorderSide(color: Colors.white)
                    ),
                    // color: Colors.green[900],
                    onPressed: ()=>{
                      valueController.clearPath()
                    },
                    child: Container(
                      child: Text("clear path"),
                    ),
                  ),
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    
                    value: searchMethod,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    iconEnabledColor: Colors.black,
                    elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  isDense: true,
                      onChanged: (String newValue) {
                                setState(() {
                                  searchMethod = newValue;
                                });
                          },
                          items: <String>['Depth First Search' , 'Breadth First Search', 'A Star Search', 'Greedy Best First Search']
                          .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                          }
                  ).toList(),
                  ),
                  SizedBox(width: 50,),
                ],
              )
            ],
          ),
          body: Center(child: Grid(valueController)), 
           floatingActionButton: FloatingActionButton(
             child: Text('search'),
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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height *0.8,
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
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
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
    // print(widget.cellController.index.toString() + " this is dragged");
    currentSelection =  widget.cellController.selectedAs.value;
  switch(currentSelection){
    case "normal":{
      currentSelection = "block";
    }
    break;
    // case "block":{
    //   currentSelection = "block";
    // }
    // break;
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
                  duration: Duration(milliseconds: 10),
                  width: cellLength,
                  height: cellLength,
                  decoration: BoxDecoration(
                 border: Border.all(color: Colors.blue[200]),
                  color: getColor(widget.cellController.selectedAs.value), 
                   ),
                  child: Center(child: widget.cellController.getWidget()),
                );
            },
          ),
        );
      },
    );
  
  }
}

