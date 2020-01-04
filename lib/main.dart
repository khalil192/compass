import 'package:flutter/material.dart';
import 'controller.dart';
import 'mazeSolver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'path finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Grid(),
    );
  }
}

class Grid extends StatefulWidget {
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  static int perRow = 30;
  static int numCells = 600;
  ValueController valueController =  ValueController(numCells,perRow);
  void solveMaze(){
    MazeSolver mazeSolver  = new MazeSolver(valueController);
    mazeSolver.fillCells();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('path finder'),
          ),
          body:
          Center(
            child: Container(
              width: 800,
              height: 500,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                  height: 1000,
                  width: 1200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      for(int i=0;i<20;i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for(int j=0;j<30;j++)
                            Cell(valueController.cellController[i*30 + j]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ()=>{
                solveMaze(),
            },
          ),
    );
  }
}


class Cell extends StatefulWidget {
  CellController cellController;
  Cell(this.cellController);
  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  Future expand() async{
  widget.cellController.length.value = widget.cellController.length.value +1;
  widget.cellController.color.value = Colors.blue[900];
  // await wait();
  // widget.cellController.color.value = Colors.white;
  widget.cellController.length.value = widget.cellController.length.value -1;
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
                  duration: Duration(milliseconds: 50),
                  width: cellLength,
                  height: cellLength,
                  decoration: BoxDecoration(
                 border: Border.all(color: Colors.black),
                 color: cellColor,
                   ),
                );
            },
          ),
        );
      },
    );
  
  }
}

