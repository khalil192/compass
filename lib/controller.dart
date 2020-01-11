
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValueController{
  List<CellController> cellController;
  int numCells;
  int perRow;
  ValueController(this.numCells,this.perRow){
    cellController = new List<CellController>(numCells);
    for(int i=0;i<numCells;i++){
      cellController[i] = new CellController(i,perRow);
    }
  }
  void selectIndex(int index){
    if(cellController[index].color.value == Colors.white){
      // cellController[index].color.value = Colors.blue;
      cellController[index].selectedAs.value = "block";
    }
  }
  void createRandomMaze(int numOfBlocks)async{
    int start = -1,dest = -1; 
    for(int i=0;i<numCells;i++){
        if(cellController[i].selectedAs.value == "start"){
          start = i;
        }
         if(cellController[i].selectedAs.value == "end"){
          dest = i;
        }
    }    
    var rng = new Random();
    for(int i=0;i<numOfBlocks;i++){
        int num = rng.nextInt(numCells);
        if(num == start || num == dest){
            continue; i--;
        }
       await wait();
        cellController[num].selectedAs.value = "block";
    }
  }
}

class CellController{
  ValueNotifier<double> length;
  ValueNotifier<Color> color;
  ValueNotifier<String> selectedAs;
  int index,perRow;
  CellController(this.index,this.perRow){
    length = new ValueNotifier(10.0);
    color = new ValueNotifier(Colors.white);
    selectedAs = new ValueNotifier("normal");
  }
  Widget getWidget(){
      if(selectedAs.value == "normal"){
        return Container();
      }
      if(selectedAs.value == "block"){
        return Container(color: Colors.blue);
      }
      if(selectedAs.value == "start"){
        return Container(
          child: Icon(Icons.send),
        );
      }
      if(selectedAs.value == "end"){
        return Container(
          child: Icon(Icons.stop),
        );
      }
      if(selectedAs.value == "currVisted"){
        return Container(color: Colors.black);
      }
      if(selectedAs.value == "destVisited"){
        return Container(color: Colors.purple);
      }
      if(selectedAs.value == "visited"){
        return Container(color: Colors.green[200]);
      }
      if(selectedAs.value == "semi-visited"){
        return Container(color: Colors.yellow[200]);
      }
      if(selectedAs.value == "in-path"){
      return Container(
        // color: Colors.black,
      child: Icon(Icons.send),
        );
      }
  }
  
  

}


Future sleepSum(int valueOne, int valueTwo) {
  return Future.delayed(const Duration(seconds: 1), () => valueOne + valueTwo);
}

Future wait() {
  // final milliseconds = lerpDouble(100, 1, speed).toInt();
  // return Future.delayed(Duration(milliseconds: milliseconds));
  return Future.delayed(Duration(milliseconds: 1));
}