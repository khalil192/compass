import 'dart:math';

import 'controller.dart';
import 'dart:collection';


/*
how this gonna work : 
this is a recursive division algorithm the four parameters of the function are 
 r1 , r2 (rows)  , c1 , c2 (cols) 
 determining the box under consideration - draw the middle lines and recurse 
 for r1 to mid to r2 and c1 to mid to c2 

*/


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
  void drawHorizontal(int up,int down) {
    if(down - up <= 1){return;}
    int mid = (up+down) ~/2;
    // print(up.toString() + " "+down.toString() +" = "+ mid.toString());
    // await waitMilliSeconds(10);

    int curr = mid*valueController.perRow;
    for(int i=0;i<valueController.perRow;i++){
      valueController.selectIndex(curr+i);
    // await waitMilliSeconds(10);
    }    
    var rng = new Random();
    int specialIndex = curr+ rng.nextInt(perRow);
    valueController.cellController[specialIndex].selectedAs.value = "notNormal";
    // await drawHorizontal(up, mid-1);
    // await drawHorizontal(mid+1, down);
  }
  Future drawVertical(int left , int right) async{
    if(right - left <=1){
      return;
    }
    int mid = (left+right) ~/2;
    await waitMicroseconds(10);

    int curr = mid;
    while(mid>0){
      valueController.selectIndex(mid);
      mid -= valueController.perRow;
    await waitMicroseconds(10);
    }
      mid =   curr;
      while(mid<numCells){
      valueController.selectIndex(mid);
      mid += valueController.perRow;
    // await waitMicroseconds(10);1
    }
    var rng = new Random();
    int specialIndex = curr * rng.nextInt(numRow);
    valueController.cellController[specialIndex].selectedAs.value = "notNormal";
    mid = curr;
    await drawVertical(left, mid-1);
    await drawVertical(mid+1 , right);
  }
  void doRecursiveDivide() async{ // x1,y1 is top left , x2,y2 is bottom right
  recurseOnBox(0,numRow, 0,perRow);
  }
  void recurseOnBox(int r1 , int r2 , int c1,int c2) {
    //base condition....
    if((r2-r1).abs() <=1 || (c2-c1).abs() <= 1){
      return;
    }
    int midRow = (r1+r2) ~/2;
    int midCol = (c1+c2) ~/2;
    //now color the midRow between the cols...
    List<int> randomCells = new List<int>(4);
    int curr = midRow*perRow + c1;
    var rng = new Random();
    randomCells[0] =rng.nextInt(midCol-c1)+ midRow*perRow + midCol;
    randomCells[1] = rng.nextInt(c2-midCol) + curr;
    for(int i=c1;i<c2;i++){
        print(curr);
        // await waitMicroseconds(10);
        valueController.selectIndex(curr);
        curr++;
    }

    //now color the midCol between the rows...
    curr = midCol + perRow * r1;
    randomCells[2] = ((rng.nextInt(r2 - midRow) + midRow)*perRow + midCol);
    randomCells[3] = ((rng.nextInt(midRow - r1) + r1)*perRow + midCol);
    for(int i=r1;i<r2;i++){
        print(curr);
        // await waitMilliSeconds(1);
        valueController.selectIndex(curr);
        curr += perRow;
    }
    for(int i=0;i<4;i++){
      if(valueController.cellController[randomCells[i]].selectedAs.value == "block"){
      valueController.cellController[randomCells[i]].selectedAs.value = "normal";
      }
    }
    int blockCell = rng.nextInt(4);
      if(valueController.cellController[randomCells[blockCell]].selectedAs.value == "normal"){
    valueController.cellController[randomCells[blockCell]].selectedAs.value = "block";
      }
  // now select 4 cells from the four lines segments -|- and randomly select 3 from them to be normal Cells
   recurseOnBox(r1 , midRow - 1 , c1 , midCol-1);
   recurseOnBox(midRow+1 ,r2, c1 , midCol-1);
   recurseOnBox(r1 , midRow - 1 , midCol+1 , c2);
   recurseOnBox(midRow + 1,r2 , midCol+1,c2);
  }
}