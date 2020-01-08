import 'dart:collection';

import 'package:flutter/material.dart';

import 'controller.dart';


//simply convert the maze into adjacency matrix of 
// cells and if the node is currently marked 
//then disconnect it from its neighbours..


class MazeSolver{
  // ValueController
  //first construct the graph with the index value... 
  final ValueController valueController;
  int numCells,perRow,numRow;
  List<List<int>> matrix;
  List<int>visi;
  MazeSolver(this.valueController){
    numCells = valueController.numCells;
    perRow = valueController.perRow;
    numRow = valueController.numCells ~/valueController.perRow;
    matrix = new List<List<int>>(numCells);
    visi = List<int>(numCells);
    for(int i=0;i<numCells;i++){
      visi[i] = 0;
      matrix[i] = new List<int>(4);
      for(int j=0;j<4;j++){
        matrix[i][j] = 0;
      }
    }
  }

  bool check(String currStr){
    if(currStr == "normal" || currStr == "end" || currStr == "start"){
        return true;
    }
    return false;
  }
  void fillCells() async{
    for(int i=0;i<numRow;i++){
      for(int j=0;j<perRow;j++){
        int curr = i*perRow + j;
        if(i-1 >= 0 && check(valueController.cellController[(i-1)*perRow + j].selectedAs.value)){
          //up
          matrix[i*perRow + j][0] = 1;
        }
        if(j+1 < perRow && check(valueController.cellController[i*perRow + j+1].selectedAs.value)){
          //right..
          matrix[curr][1] = 1;
        }
        if(i+1 < numRow && check(valueController.cellController[(i+1)*perRow + j].selectedAs.value)){
            //down
            matrix[i*perRow + j][2] = 1;
        }
        if(j-1 >=0 && check(valueController.cellController[i*perRow + j-1].selectedAs.value )){
            //left
            matrix[i*perRow + j][3] = 1;
        }
      }
    }
    // print(matrix[0][0]);
    // print(matrix[0][1]);
    // print(matrix[0][2]);

    // await dfs(0,381);
    // await bfs(0,398);
  }

  void findPath(String method){
    int start = -1,dest = -1; 
    for(int i=0;i<numCells;i++){
        if(valueController.cellController[i].selectedAs.value == "start"){
          start = i;
        }
         if(valueController.cellController[i].selectedAs.value == "end"){
          dest = i;
        }
    }
    switch(method){
    case  "dfs" :{ dfs(start,dest); }
    break;
     case  "bfs" :{ bfs(start,dest); }
    break;
    }
  }
  Future<bool> dfs(int curr,int dest) async{
      visi[curr] = 1;
      if(curr == dest){
      // valueController.cellController[curr].color.value = Colors.red;
      valueController.cellController[curr].selectedAs.value = "destVisited";
      return Future.value(true);
      }
      int i= curr ~/perRow,j = curr%perRow;
      // print(i.toString() + " hhh"+ j.toString());
      valueController.cellController[curr].selectedAs.value = "currVisted";
      await wait();
      valueController.cellController[curr].selectedAs.value = "visited";
      if(i > 0 ){ 
        // print('this');
        if(matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          if (await dfs((i-1)*perRow+j , dest)){
            return Future.value(true);
          }
        }
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          if(await dfs(i*perRow + j+1,dest)){
            return Future.value(true);
          }
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
         if (await dfs((i+1)*perRow+j , dest)){
          return Future.value(true);
         }
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            if(await dfs(i*perRow + j-1 , dest )){
                          return Future.value(true);
            }
        }
        valueController.cellController[curr].color.value = Colors.orange;
        return Future.value(false);
  }
  Future bfs(int src,int dest) async{
    Queue queue = new Queue();
    queue.add(src);
    // int count = 600
    while(queue.isEmpty == false){
      // count -=1;
      int curr = queue.removeFirst();
      // print(curr);
      if(visi[curr] == 1){
        continue;
      }
      visi[curr] = 1;
      valueController.cellController[curr].selectedAs.value = "visited";
      await wait();
      if(curr == dest){
      valueController.cellController[curr].selectedAs.value = "destVisited";
      return;
      }
      int i= curr ~/perRow,j = curr%perRow;
      valueController.cellController[curr].selectedAs.value = "currVisted";
      await wait();
      valueController.cellController[curr].selectedAs.value = "visited";

      if(i > 0 && matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
         queue.add(curr-perRow);
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          queue.add(curr+1);
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          queue.add(curr + perRow);
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            queue.add(curr-1);
        }
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