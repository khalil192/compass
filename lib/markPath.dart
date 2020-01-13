import 'controller.dart';


class MarkPath{
  List<int> parentList;
  ValueController valueController;
  int numCells , perRow,numRow;
  List<int>visi;
  MarkPath(this.valueController , this.parentList){
    numCells = valueController.numCells;
    perRow =  valueController.perRow;
  }
  // intially curr will be called as destnode
  //the previous node's position will be decided as per current node 
  void markPath(int curr){
    int prev = parentList[curr];
    while(prev != parentList[prev]){
        if(prev == curr - perRow){
          //prev is at top so arrow to be down
          valueController.cellController[prev].selectedAs.value = "in-path-down";
        }
        if(prev == curr + perRow){
          //prev is at down so arrow to be down
          valueController.cellController[prev].selectedAs.value = "in-path-up";
        }
        if(prev == curr - 1){
          //prev is at left so arrow to be right
          valueController.cellController[prev].selectedAs.value = "in-path-right";
        }
        if(prev == curr + 1){
          //prev is at right so arrow to be left
          valueController.cellController[prev].selectedAs.value = "in-path-left";
        }
        curr = prev;
        prev = parentList[prev];
    }
  }
}