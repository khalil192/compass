import 'package:pathvisualizer/markPath.dart';

import 'controller.dart';

 class AStar{
 List<int> parentList;
  ValueController valueController;
  int numCells , perRow,numRow;
  List<int>visi;
  List<List<int>> matrix;
  AStar(this.valueController,this.parentList,this.matrix){
      numCells = valueController.numCells;
      perRow = valueController.perRow;
      numRow = numCells ~/ perRow;
      visi = new List<int>(numCells);
      for(int i=0;i<numCells;i++){
        visi[i]= 0;
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
        if(valueController.cellController[curr].selectedAs.value == "normal"){
        valueController.cellController[curr].selectedAs.value = "visited";
        }
        await wait();
        if(curr == dest){
          MarkPath markPathObject = new MarkPath(valueController, parentList);
          markPathObject.markPath(curr);
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


