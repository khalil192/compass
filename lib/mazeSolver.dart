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
  void fillCells() async{
    for(int i=0;i<numRow;i++){
      for(int j=0;j<perRow;j++){
        int curr = i*perRow + j;
        if(i-1 >= 0 && valueController.cellController[(i-1)*perRow + j].color.value == Colors.white){
          //up
          matrix[i*perRow + j][0] = 1;
        }
        if(j+1 < perRow && valueController.cellController[i*perRow + j+1].color.value == Colors.white){
          //right..
          matrix[curr][1] = 1;
        }
        if(i+1 < numRow && valueController.cellController[(i+1)*perRow + j].color.value == Colors.white){
            //down
            matrix[i*perRow + j][2] = 1;
        }
        if(j-1 >=0 && valueController.cellController[i*perRow + j-1].color.value == Colors.white){
            //left
            matrix[i*perRow + j][3] = 1;
        }
      }
    }
    print(matrix[0][0]);
    print(matrix[0][1]);
    print(matrix[0][2]);
    await dfs(0,30,visi);
  }
  Future<bool> dfs(int curr,int dest,List<int> visi) async{
      visi[curr] = 1;
      if(curr == dest){
      valueController.cellController[curr].color.value = Colors.green;
      return Future.value(true);
      }
      await wait();
      int i= curr ~/perRow,j = curr%perRow;
      // print(i.toString() + " hhh"+ j.toString());
      valueController.cellController[curr].color.value = Colors.black;
      if(i > 0 ){ 
        // print('this');
        if(matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          if (await dfs((i-1)*perRow+j , dest,visi)){
            return Future.value(true);
          }
        }
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          if(await dfs(i*perRow + j+1,dest,visi)){
            return Future.value(true);
          }
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
         if (await dfs((i+1)*perRow+j , dest,visi)){
          return Future.value(true);
         }
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            if(await dfs(i*perRow + j-1 , dest , visi)){
                          return Future.value(true);
            }
        }
        return Future.value(false);
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