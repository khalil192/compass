import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pathvisualizer/aStarSearch.dart';

import 'controller.dart';
import 'dfs.dart';
import 'bfs.dart';
import 'aStarSearch.dart';

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
  }

  void findPath(String method){
    int start = -1,dest = -1; 
    List<int> parentList = new List<int>(numCells);
    for(int i=0;i<numCells;i++){
        parentList[i] = i;
        if(valueController.cellController[i].selectedAs.value == "start"){
          start = i;
        }
         if(valueController.cellController[i].selectedAs.value == "end"){
          dest = i;
        }
    }

    switch(method){
    case  "dfs" :{
        Dfs dfsObject  = new Dfs(valueController, parentList, matrix);
        dfsObject.dfs(start,dest,parentList);
        }
    break;
     case  "bfs" :{
        Bfs bfsObject = new Bfs(valueController,parentList,matrix);
        bfsObject.bfs(start,dest,parentList);
         }
    break;
    case  "aStar" :{ 
      AStar aStarObject = new AStar(valueController, parentList, matrix);
      aStarObject.aStarSearch(start,dest); 
      }
    break;
    }
  }
}