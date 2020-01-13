import 'controller.dart';
import 'markPath.dart';

 class GreedyBFS{
  List<int> parentList;
  ValueController valueController;
  int numCells , perRow,numRow;
  List<int>visi;
  List<List<int>> matrix;
  GreedyBFS(this.valueController,this.parentList,this.matrix){
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
  void greedyBFSSearch(int src , int dest) async{
    List<bool> closedList = new List<bool>(numCells);
    List<int> parentList = new List<int> (numCells);
    List<cellFValues> cellDetails = new List<cellFValues>(numCells);
    for(int i=0;i<numCells;i++){
      closedList[i] = false;
      cellDetails[i] = new cellFValues(-2,i);
      parentList[i]=i;
    }
    int curr = src;
    int curri= curr ~/perRow,currj = curr % perRow;
    Set<Pair> openList = new Set<Pair>();
    Pair currPair = new Pair(heuristic(curr, dest), src);
    cellDetails[curr] = cellFValues(currPair.fValue, curr);
    openList.add(currPair);
    print(dest.toString().toString());
    while(openList.isNotEmpty){
        currPair = await removeMin(openList);
        curr = currPair.cellNum;
        curri = currPair.cellNum ~/ perRow;
        currj = currPair.cellNum % perRow;
        closedList[curr] = true;
        if(valueController.cellController[curr].selectedAs.value == "normal"){
        valueController.cellController[curr].selectedAs.value = "visited";
        }
        await wait();
        if(curr == dest){
          MarkPath markPathObject = new MarkPath(valueController, parentList);
          markPathObject.markPath(curr);
                  return;
        }
        // valueController.cellController[curr].selectedAs.value = "in-path";
        int  fNew , hNew;
         if(curri > 0 && matrix[curr][0] == 1 && closedList[curr-perRow] == false){
          //up
        hNew = heuristic(curr-perRow, dest);
        fNew = hNew;
        if(cellDetails[curr-perRow].fValue == -2 || cellDetails[curr-perRow].fValue > fNew){
          openList.remove(Pair(cellDetails[curr-perRow].fValue , curr-perRow));
          openList.add(Pair(fNew ,curr-perRow));
          cellDetails[curr-perRow] = cellFValues(fNew,curr);
          parentList[curr-perRow] = curr;
        // valueController.cellController[curr-perRow].selectedAs.value = "semi-visited";
        }
      }
       if(currj+1 < perRow && matrix[curr][1] == 1 && closedList[curr+1] == false){
          //right..
        hNew = heuristic(curr+1, dest);
        fNew = hNew;

        if(cellDetails[curr+1].fValue == -2 || cellDetails[curr+1].fValue > fNew){
          openList.remove(Pair(cellDetails[curr+1].fValue , curr+1));
          openList.add(Pair(fNew ,curr+1));
          cellDetails[curr+1] = cellFValues(fNew,curr);
          parentList[curr+1] = curr;
          // valueController.cellController[curr+1].selectedAs.value = "semi-visited";
        }
        }
        if(curri+1 < numRow && matrix[curr][2] == 1 && closedList[curr+perRow] == false){
          //down
        hNew = heuristic(curr+perRow, dest);
        fNew = hNew;
        if(cellDetails[curr+perRow].fValue == -2 || cellDetails[curr+perRow].fValue > fNew){
          openList.remove(Pair(cellDetails[curr+perRow].fValue , curr+perRow));
          openList.add(Pair(fNew ,curr+perRow));
          cellDetails[curr+perRow] = cellFValues(fNew,curr);
          parentList[curr+perRow] = curr;
          // valueController.cellController[curr+perRow].selectedAs.value = "semi-visited";
        }
        }
        if(currj>0 && matrix[curr][3] == 1 && closedList[curr-1] == false){
          //left.
        hNew = heuristic(curr-1, dest);
        fNew = hNew ;
        if(cellDetails[curr-1].fValue == -2 || cellDetails[curr-1].fValue > fNew){
          openList.remove(Pair(cellDetails[curr-1].fValue , curr-1));
          openList.add(Pair(fNew ,curr-1));
          cellDetails[curr-1] = cellFValues(fNew,curr);
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
class cellFValues{
  int fValue,parent;
  cellFValues(this.fValue,this.parent);
}


