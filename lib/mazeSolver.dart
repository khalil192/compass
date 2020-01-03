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
  MazeSolver(this.valueController){
    numCells = valueController.numCells;
    perRow = valueController.perRow;
    numRow = valueController.numCells ~/valueController.perRow;
    matrix = new List<List<int>>(numRow);
    for(int i=0;i<numRow;i++){
      matrix[i] = new List<int>(numCells);
      for(int j=0;j<perRow;j++){
        matrix[i][j] = 1;
      }
    }
  }


}