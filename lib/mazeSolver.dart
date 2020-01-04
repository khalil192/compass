// import 'package:flutter/material.dart';

// import 'controller.dart';


// //simply convert the maze into adjacency matrix of 
// // cells and if the node is currently marked 
// //then disconnect it from its neighbours..


// class Matrix{
//   // ValueController
//   //first construct the graph with the index value... 
//   final ValueController valueController;
//   int numCells,perRow,numRow;
//   List<List<int>> matrix;
//   Matrix(this.valueController){
//     numCells = valueController.numCells;
//     perRow = valueController.perRow;
//     numRow = valueController.numCells ~/valueController.perRow;
//     matrix = new List<List<int>>(numCells);
//     for(int i=0;i<numCells;i++){
//       matrix[i] = new List<int>(4);
//       //for each cell 4 directions ...
//       //0 for up , 1 for right 2 for west 3 for left
//       //N - 0 E - 1 W - 2 S- 3 
//     }
//   }
//   Future fillCell(int currIndex) async{
//       print(currIndex);
//       int row = currIndex ~/ perRow ,col = currIndex %perRow;
//        //0 for up , 1 for right 2 for down 3 for left
//       //N - 0 E - 1 W - 2 S- 3 
//       for(int i=0;i<4;i++){
//         matrix[currIndex][i] = 0;
//       }
//       if( col > 0  && valueController.cellController[currIndex -1].color.value == Colors.white){
//            //conditionCheck - left
//           matrix[currIndex][3] = 1;
//       }
//       if(col < perRow-1 && valueController.cellController[currIndex +1].color.value == Colors.white ){
//           //conditionCheck - right
//           matrix[currIndex][1] = 1;
//       }
//       if( row >=0  && valueController.cellController[currIndex- perRow].color.value == Colors.white){
//           //conditionCheck - down
//           matrix[currIndex][2] = 1;
        
//       }
//       if(row < numRow-1  && valueController.cellController[currIndex+ perRow].color.value == Colors.white ){
//           //conditionCheck - up
//           matrix[currIndex][0] = 1;
//       }
//     }
//   Future fillMatrix() async{
//     for(int currIndex=0;currIndex<numCells;currIndex++){
//       //for each row check if adjacent elements can be 
//       await fillCell(currIndex);
//     // now our graph is constructed...
//     //now solve using simple dfs...
//   }
//   }
//   Future solveDfs()async{
//     List<int>visi = new List<int> (numCells);
//    await fillMatrix();
//     print(matrix);
//     // for(int i=0;i<numCells;i++){
//       // visi[i] = 0;
//     // }
//     // int /src = 0,dest = 98;
//     // dfs(src,dest,visi);
//   }
//   void dfs(int curr , int dest , List<int>visi) async{
//       visi[curr] = 1;
//       valueController.cellController[curr].color.value = Colors.red;
//       // await wait();
//       //0 for up , 1 for right 2 for down 3 for left
//       //N - 0 E - 1 W - 2 S- 3 
//       print(curr);
//       int adj =curr - perRow;
//       if(matrix[curr][0] == 1  && visi[adj] ==0){
//         dfs(adj,dest, visi);
//       }
//       adj = curr + 1;
//       if(matrix[curr][1] == 1 && visi[adj] == 0){
//         dfs(adj , dest, visi);
//       }
//       adj = curr+perRow;
//       if(matrix[curr][2] == 1 && visi[adj] == 0){
//         dfs(adj , dest, visi);
//       }
//        adj = curr-1;
//       if(matrix[curr][3] == 1 && visi[adj] == 0){
//         dfs(adj , dest, visi);
//       }
//       // await wait();
//     valueController.cellController[curr].color.value = Colors.black;
//   }

// }

// Future sleepSum(int valueOne, int valueTwo) {
//   return Future.delayed(const Duration(seconds: 1), () => valueOne + valueTwo);
// }

// Future wait() {
//   // final milliseconds = lerpDouble(100, 1, speed).toInt();
//   // return Future.delayed(Duration(milliseconds: milliseconds));
//   return Future.delayed(Duration(milliseconds: 1000));
// }