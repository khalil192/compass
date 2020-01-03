// import 'package:compass/mazeSolver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'changeController.dart';
import 'dart:ui';

int numNodes = 500;
int numRows = 5;
int numCols = 10;
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueController valueController =  new ValueController(500);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('maze solver'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child : Cell(valueController.cellController[0]),
            // child: Grid(valueController),
            // child: Cell(valueController.cellController[0]),
            // child: Grid(valueController),
            // child: Row(
            //   children: <Widget>[
            //       Cell(valueController.cellController[0]),
            //       Cell(valueController.cellController[1]),
            //       Cell(valueController.cellController[2]),

            //   ],
            // ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed :()=>{
              // expand()
             } ,
          ),
        ),
      )
    );
  }
}

class Grid extends StatefulWidget {
  ValueController valueController;
  Grid(this.valueController);
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for(int i=0;i<10;i++)
        Cell(widget.valueController.cellController[i]),
      ],),
    );
    // return Container(
    //   child: GridView.count(
    //     crossAxisCount: 50,
    //     mainAxisSpacing: 1,
    //     crossAxisSpacing: 1,
    //     children: <Widget>[
    //       for(int i=0;i<500;i++)
    //         Cell(widget.valueController.cellController[i]),
    //     ],
    //   ),
    // );
  }
}

// class Grid extends StatefulWidget {
//  final ValueController valueController;
//   Grid(this.valueController);
//   @override
//   GridState createState() {
//     return new GridState();
//   }
// // }

// class GridState extends State<Grid> {
//   final Set<int> selectedIndexes = Set<int>();
//   final key = GlobalKey();
//   final Set<_Foo> _trackTaped = Set<_Foo>();

//   _detectTapedItem(PointerEvent event) {
//     final RenderBox box = key.currentContext.findRenderObject();
//     final result = BoxHitTestResult();
//     Offset local = box.globalToLocal(event.position);
//     if (box.hitTest(result, position: local)) {
//       for (final hit in result.path) {
//         /// temporary variable so that the [is] allows access of [index]
//         final target = hit.target;
//         if (target is _Foo && !_trackTaped.contains(target)) {
//           _trackTaped.add(target);
  //         _selectIndex(target.index);
  //       }
  //     }
  //   }
  // }

  // _selectIndex(int index) {
  //   setState(() {
  //     selectedIndexes.add(index);
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // for(int index in selectedIndexes){
  //   //   widget.changeController.changeValue(index); 
  //   //   }
  //   // print(selectedIndexes);
  //   return Listener(
      // onPointerDown: _detectTapedItem,
      // onPointerMove: _detectTapedItem,
      // onPointerUp: _clearSelection,
      // child: GridView.builder(
      //   key: key,
      //   itemCount: widget.valueController.numCells,
      //   physics: NeverScrollableScrollPhysics(),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 40, // change this value
        //   childAspectRatio: 1.0,
        //   crossAxisSpacing: 5.0,
        //   mainAxisSpacing: 5.0,
        // ),
  //       itemBuilder: (context, index) {
  //         return Foo(
  //           index: index,
  //           child: Cell(widget.valueController.cellController[index]),
  //         );
  //       },
  //     ),
  //   );
  // }

//   void _clearSelection(PointerUpEvent event) {
//     _trackTaped.clear();
//     setState(() {
//       selectedIndexes.clear();
//     });
//   }
// }

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

class _CellState extends State<Cell> {
  Future expand() async{
  widget.cellController.length.value *= 1.33;
  print('this is');
  widget.cellController.color.value = Colors.green;
  await wait();
  widget.cellController.color.value = Colors.blue;
  widget.cellController.length.value *= 0.75;
  print('boring');
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: widget.cellController.length,
      builder: (context,cellLength,child){
        return GestureDetector(
          onTap: ()=>{expand()},
          child: ValueListenableBuilder(
            valueListenable: widget.cellController.color,
            builder: (context, cellColor, child){
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: cellLength,
                  height: cellLength,
                  color: cellColor,
                );
            },
          ),
        );
      },
    );
  
  }
}


Future sleepSum(int valueOne, int valueTwo) {
  return Future.delayed(const Duration(seconds: 1), () => valueOne + valueTwo);
}

Future wait() {
  // final milliseconds = lerpDouble(100, 1, speed).toInt();
  // return Future.delayed(Duration(milliseconds: milliseconds));
  return Future.delayed(Duration(milliseconds: 1000));
}


class ValueController{
  List<CellController> cellController;
  int numCells;
  ValueController(this.numCells){
    cellController = new List<CellController>(numCells);
    for(int i=0;i<numCells;i++){
      cellController[i] = new CellController();
    }
  }
}

class CellController{
  ValueNotifier<double> length;
  ValueNotifier<Color> color;
  CellController(){
    length = new ValueNotifier(25.0);
    color = new ValueNotifier(Colors.blue);
  }
}