import 'package:flutter/material.dart';
import 'controller.dart';
import 'markPath.dart';

class Dfs{
  List<int> parentList;
  ValueController valueController;
  int numCells , perRow,numRow;
  List<int>visi;
  List<List<int>> matrix;
  Dfs(this.valueController,this.parentList,this.matrix){
      numCells = valueController.numCells;
      perRow = valueController.perRow;
      numRow = numCells ~/ perRow;
      visi = new List<int>(numCells);
      for(int i=0;i<numCells;i++){
        visi[i]= 0;
      }
  }
  Future<bool> dfs(int curr,int dest,List<int> parentList) async{
      visi[curr] = 1;
        await wait();
        if(curr == dest){
          MarkPath markPathObject = new MarkPath(valueController, parentList);
          markPathObject.markPath(curr);
          return Future.value(true);
      }
       if(valueController.cellController[curr].selectedAs.value == "no  rmal" || valueController.cellController[curr].selectedAs.value == "semi-visited" ){
        valueController.cellController[curr].selectedAs.value = "visited";
        }
      int i= curr ~/perRow,j = curr%perRow;
      if(i > 0 ){
        if(matrix[curr][0] == 1 && visi[curr-perRow]==0){
          //up
          parentList[curr-perRow] = curr;
          if(valueController.cellController[(i-1)*perRow + j].selectedAs.value != "end"){ 
          valueController.cellController[(i-1)*perRow + j].selectedAs.value = "semi-visited";
          }
          if (await dfs((i-1)*perRow+j , dest,parentList)){
            return Future.value(true);
          }
          
        }
      }
        if(j+1 < perRow && matrix[curr][1] == 1 && visi[i*perRow + j+1] == 0){
          //right..
          if(valueController.cellController[i*perRow + j+1].selectedAs.value != "end"){ 
          valueController.cellController[i*perRow + j+1].selectedAs.value = "semi-visited";
        }
          parentList[curr+1] = curr;
          if(await dfs(i*perRow + j+1,dest,parentList)){
            return Future.value(true);
          }
        }
        if(i+1 < numRow && matrix[curr][2] == 1 && visi[(i+1)*perRow + j] == 0){
            //down
          parentList[curr+perRow] = curr;
          if(valueController.cellController[(i+1)*perRow + j].selectedAs.value != "end"){
          valueController.cellController[(i+1)*perRow + j].selectedAs.value = "semi-visited";
          }
         if (await dfs((i+1)*perRow+j , dest,parentList)){
          return Future.value(true);
         }
        }
        if(j-1 >=0 && visi[i*perRow + j-1] == 0 && matrix[curr][3] == 1){
            //left
            if(valueController.cellController[i*perRow + j-1].selectedAs.value != "end"){
            valueController.cellController[i*perRow + j-1].selectedAs.value = "semi-visited";
            }
            parentList[curr-1] = curr;
            if(await dfs(i*perRow + j-1 , dest,parentList )){
                          return Future.value(true);
            }
        }
        valueController.cellController[curr].color.value = Colors.orange;
        return Future.value(false);
  }
}