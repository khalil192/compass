import 'package:flutter/material.dart';
import 'package:pathvisualizer/controller.dart';
import 'dart:collection';
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
      if(visi[curr] == 1){
        continue;
      }
      visi[curr] = 1;
      valueController.cellController[curr].selectedAs.value = "visited";
      await wait();
      if(curr == dest){
      valueController.cellController[curr].selectedAs.value = "destVisited";
      while(curr != parentList[curr]){
      valueController.cellController[curr].selectedAs.value = "in-path";
      await wait();
        curr = parentList[curr];
      }
      valueController.cellController[curr].selectedAs.value = "in-path";
      return;
      }
      int i= curr ~/perRow,j = curr%perRow;
      valueController.cellController[curr].selectedAs.value = "currVisted";
      await wait();
      valueController.cellController[curr].selectedAs.value = "visited";

      if(i > 0 && matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          parentList[curr-perRow] = curr;
         queue.add(curr-perRow);
        valueController.cellController[curr-perRow].selectedAs.value = "semi-visited";
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          parentList[curr+1] = curr;
          queue.add(curr+1);
          valueController.cellController[curr+1].selectedAs.value = "semi-visited";
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          parentList[curr+perRow] = curr;
          queue.add(curr + perRow);
          valueController.cellController[curr+perRow].selectedAs.value = "semi-visited";
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            parentList[curr-1] = curr;
            queue.add(curr-1);
            valueController.cellController[curr-1].selectedAs.value = "semi-visited";
        }
    }
  }
}
