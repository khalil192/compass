
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
  }
}
