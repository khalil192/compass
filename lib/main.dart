import 'package:flutter/material.dart';
import 'controller.dart';
import 'mazeSolver.dart';

//git push origin --set-upstream gh-pages
void main() => runApp(MyApp());

String searchMethod = "dfs";

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
  static int perRow = 35;
  static int numCells = 1225;
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
                ],
              )
            ],
          ),
          body: Grid(valueController), 
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
  // static int perRow = 35;
  // static int numCells = 1225;   
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: GridView.count(
        crossAxisCount: widget.valueController.perRow,
        children: <Widget>[
          for(int i=0;i<widget.valueController.numCells;i++)
            Cell(widget.valueController.cellController[i]),
        ],
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
                //  border: Border.all(color: Colors.black),
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

