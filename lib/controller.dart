
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
      cellController[index].color.value = Colors.blue;
    }
  }
}

class CellController{
  ValueNotifier<double> length;
  ValueNotifier<Color> color;
  int index,perRow;
  CellController(this.index,this.perRow){
    length = new ValueNotifier(10.0);
    color = new ValueNotifier(Colors.white);
  }
}
