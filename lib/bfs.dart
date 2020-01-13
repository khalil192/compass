import 'controller.dart';
import 'dart:collection';

import 'markPath.dart';
class Bfs{ 
  List<int> parentList;
  ValueController valueController;
  int numCells , perRow,numRow;
  List<int>visi;
  List<List<int>> matrix;
  Bfs(this.valueController,this.parentList,this.matrix){
      numCells = valueController.numCells;
      perRow = valueController.perRow;
      numRow = numCells ~/ perRow;
      visi = new List<int>(numCells);
      for(int i=0;i<numCells;i++){
        visi[i]= 0;
      }
  }

Future bfs(int src,int dest,List<int> parentList) async{
    Queue queue = new Queue();
    queue.add(src);
    // int count = 600
    while(queue.isEmpty == false){
      // count -=1;
      int curr = queue.removeFirst();
      visi[curr] = 1;
        await wait();
        if(curr == dest){
          MarkPath markPathObject = new MarkPath(valueController, parentList);
          markPathObject.markPath(curr);
          return;
        }
      int i= curr ~/perRow,j = curr%perRow;
      if(valueController.cellController[curr].selectedAs.value == "normal"){
      valueController.cellController[curr].selectedAs.value = "currVisted";
      await wait();
      valueController.cellController[curr].selectedAs.value = "visited";
      }
      if(i > 0 && matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          parentList[curr-perRow] = curr;
         queue.add(curr-perRow);
         if(valueController.cellController[curr-perRow].selectedAs.value == "normal"){
        valueController.cellController[curr-perRow].selectedAs.value = "semi-visited";
      }
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          parentList[curr+1] = curr;
          queue.add(curr+1);
          if(valueController.cellController[curr+1].selectedAs.value == "normal"){
          valueController.cellController[curr+1].selectedAs.value = "semi-visited";
          }
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          parentList[curr+perRow] = curr;
          queue.add(curr + perRow);
          if(valueController.cellController[curr+perRow].selectedAs.value == "normal"){
          valueController.cellController[curr+perRow].selectedAs.value = "semi-visited";
          }
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            parentList[curr-1] = curr;
            queue.add(curr-1);
           if(valueController.cellController[curr-1].selectedAs.value == "normal"){
            valueController.cellController[curr-1].selectedAs.value = "semi-visited";
            }
        }
    }
  }
}
