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
    case  "aStar" :{ aStarSearch(start,dest); }
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
      valueController.cellController[curr].selectedAs.value = "currVisted";
      await wait();
      valueController.cellController[curr].selectedAs.value = "visited";
      if(i > 0 ){ 
          valueController.cellController[(i-1)*perRow + j].selectedAs.value = "semi-visited";
        if(matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          if (await dfs((i-1)*perRow+j , dest)){
            return Future.value(true);
          }
        }
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
         valueController.cellController[i*perRow + j+1].selectedAs.value = "semi-visited";
          if(await dfs(i*perRow + j+1,dest)){
            return Future.value(true);
          }
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          valueController.cellController[(i+1)*perRow + j].selectedAs.value = "semi-visited";
         if (await dfs((i+1)*perRow+j , dest)){
          return Future.value(true);
         }
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            valueController.cellController[i*perRow + j-1].selectedAs.value = "semi-visited";
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
        valueController.cellController[curr-perRow].selectedAs.value = "semi-visited";
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          queue.add(curr+1);
          valueController.cellController[curr+1].selectedAs.value = "semi-visited";
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          queue.add(curr + perRow);
          valueController.cellController[curr+perRow].selectedAs.value = "semi-visited";
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            queue.add(curr-1);
            valueController.cellController[curr-1].selectedAs.value = "semi-visited";
        }
    }
  }
  Future<Pair> removeMin(Set<Pair> openList){
    Pair currPair = Pair(100000,-1);
    for( Pair p in openList){
      if(p.fValue < currPair.fValue){
        currPair = p;
      }
    }
    openList.remove(currPair);
    return Future.value(currPair);
  } 
  int heuristic(int curr,int dest){
    int curri= curr ~/perRow,currj = curr%perRow;
    int desti = dest ~/perRow , destj = dest%perRow;
    int val =  (curri-desti).abs() + (currj - destj).abs();
    return val*5;
  }
  void aStarSearch(int src , int dest) async{
    List<bool> closedList = new List<bool>(numCells);
    List<int> parentList = new List<int> (numCells);
    List<cellGHFvalues> cellDetails = new List<cellGHFvalues>(numCells);
    for(int i=0;i<numCells;i++){
      closedList[i] = false;
      cellDetails[i] = new cellGHFvalues(0,0,-2,i);
      parentList[i]=i;
    }
    int curr = src;
    int curri= curr ~/perRow,currj = curr % perRow;
    Set<Pair> openList = new Set<Pair>();
    Pair currPair = new Pair(heuristic(curr, dest), src);
    cellDetails[curr] = cellGHFvalues(0, currPair.fValue, currPair.fValue, curr);
    openList.add(currPair);
    print(dest.toString().toString());
    while(openList.isNotEmpty){
        currPair = await removeMin(openList);
        curr = currPair.cellNum;
        curri = currPair.cellNum ~/ perRow;
        currj = currPair.cellNum % perRow;
        closedList[curr] = true;
        print(curr.toString() + '  = ' + curri.toString() +' ' + currj.toString());
        valueController.cellController[curr].selectedAs.value = "visited";
        await wait();

        if(curr == dest){
        valueController.cellController[curr].selectedAs.value = "destVisited";
        while(parentList[curr] != curr){
          await wait();
          valueController.cellController[curr].selectedAs.value = "in-path";
          curr = parentList[curr];
        }
        valueController.cellController[curr].selectedAs.value = "in-path";
        return;
        }
        int gNew , fNew , hNew;
        gNew = cellDetails[curr].gValue + 1;
         if(curri > 0 && matrix[curr][0] == 1 && closedList[curr-perRow] == false){
          //up
        hNew = heuristic(curr-perRow, dest);
        fNew = hNew + gNew;
        if(cellDetails[curr-perRow].fValue == -2 || cellDetails[curr-perRow].fValue > fNew){
          openList.remove(Pair(cellDetails[curr-perRow].fValue , curr-perRow));
          openList.add(Pair(fNew ,curr-perRow));
          cellDetails[curr-perRow] = cellGHFvalues(gNew, hNew, fNew,curr);
          parentList[curr-perRow] = curr;
        // valueController.cellController[curr-perRow].selectedAs.value = "semi-visited";
        }
      }
       if(currj+1 < perRow && matrix[curr][1] == 1 && closedList[curr+1] == false){
          //right..
        hNew = heuristic(curr+1, dest);
        fNew = hNew + gNew;

        if(cellDetails[curr+1].fValue == -2 || cellDetails[curr+1].fValue > fNew){
          openList.remove(Pair(cellDetails[curr+1].fValue , curr+1));
          openList.add(Pair(fNew ,curr+1));
          cellDetails[curr+1] = cellGHFvalues(gNew, hNew, fNew,curr);
          parentList[curr+1] = curr;
          // valueController.cellController[curr+1].selectedAs.value = "semi-visited";
        }
        }
        if(curri+1 < numRow && matrix[curr][2] == 1 && closedList[curr+perRow] == false){
          //down
        hNew = heuristic(curr+perRow, dest);
        fNew = hNew + gNew;
        if(cellDetails[curr+perRow].fValue == -2 || cellDetails[curr+perRow].fValue > fNew){
          openList.remove(Pair(cellDetails[curr+perRow].fValue , curr+perRow));
          openList.add(Pair(fNew ,curr+perRow));
          cellDetails[curr+perRow] = cellGHFvalues(gNew, hNew, fNew,curr);
          parentList[curr+perRow] = curr;
          // valueController.cellController[curr+perRow].selectedAs.value = "semi-visited";
        }
        }
        if(currj>0 && matrix[curr][3] == 1 && closedList[curr-1] == false){
          //left.
        hNew = heuristic(curr-1, dest);
        fNew = hNew + gNew;
        if(cellDetails[curr-1].fValue == -2 || cellDetails[curr-1].fValue > fNew){
          openList.remove(Pair(cellDetails[curr-1].fValue , curr-1));
          openList.add(Pair(fNew ,curr-1));
          cellDetails[curr-1] = cellGHFvalues(gNew, hNew, fNew,curr);
          parentList[curr-1] = curr;
          // valueController.cellController[curr-1].selectedAs.value = "semi-visited";
        }
        }
    }
  }
}

class Pair{
  int fValue, cellNum;
  Pair(this.fValue , this.cellNum);
}
class cellGHFvalues{
  int gValue,fValue,hValue,parent;
  cellGHFvalues(this.gValue,this.hValue,this.fValue,this.parent);
}


Future sleepSum(int valueOne, int valueTwo) {
  return Future.delayed(const Duration(seconds: 1), () => valueOne + valueTwo);
}

Future wait() {
  // final milliseconds = lerpDouble(100, 1, speed).toInt();
  // return Future.delayed(Duration(milliseconds: milliseconds));
  return Future.delayed(Duration(milliseconds: 1));
}