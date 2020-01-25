import 'dart:math';

import 'controller.dart';
import 'dart:collection';


class RecursiveDivision{
  ValueController valueController;
  int numCells;
  int numRow;
  int perRow;
  RecursiveDivision(this.valueController){
    numCells = valueController.numCells;
  numRow = valueController.numCells ~/ valueController.perRow;
  perRow = valueController.perRow;
  }
  Future drawHorizontal(int up,int down) async{
    if(down - up <= 1){return;}
    int mid = (up+down) ~/2;
    // print(up.toString() + " "+down.toString() +" = "+ mid.toString());
    await wait();
    int curr = mid*valueController.perRow;
    for(int i=0;i<valueController.perRow;i++){
      valueController.selectIndex(curr+i);
    }    
    var rng = new Random();
    int specialIndex = curr+ rng.nextInt(perRow);
    valueController.cellController[specialIndex].selectedAs.value = "notNormal";
    await drawHorizontal(up, mid-1);
    await drawHorizontal(mid+1, down);
  }
  Future drawVertical(int left , int right) async{
    if(right - left <=1){
      return;
    }
    int mid = (left+right) ~/2;
    await wait();
    int curr = mid;
    while(mid>0){
      valueController.selectIndex(mid);
      mid -= valueController.perRow;
    }
      mid =   curr;
      while(mid<numCells){
      valueController.selectIndex(mid);
      mid += valueController.perRow;
    }
    var rng = new Random();
    int specialIndex = curr * rng.nextInt(numRow);
    valueController.cellController[specialIndex].selectedAs.value = "notNormal";
    mid = curr;
    await drawVertical(left, mid-1);
    await drawVertical(mid+1 , right);
  }
  void doRecursiveDivide() async{ // x1,y1 is top left , x2,y2 is bottom right
   await drawHorizontal(0, numRow);
   await drawVertical(0, valueController.perRow);
   for(int i=0;i<numCells;i++){
     if(valueController.cellController[i].selectedAs.value == "notNormal"){
       valueController.cellController[i].selectedAs.value = "normal";
     }
   }
  }
}