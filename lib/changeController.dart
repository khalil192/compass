import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChangeController{
  List<ValueNotifier<Color>> valueNotifiers;
  List<int> values;
  List<DateTime> timeStamps;
  int numNodes;
  ChangeController(this.numNodes){
    valueNotifiers = new List<ValueNotifier<Color>>(numNodes);    
    values = new List<int>(numNodes);
    timeStamps = new List<DateTime> (numNodes);
    for(int i=0;i<numNodes;i++){
      values[i] = 0;
      valueNotifiers[i] = new ValueNotifier(Colors.blue);  
      timeStamps[i] =  new DateTime.now();
    }
  }
  void changeValue(int index){
    DateTime curr = new DateTime.now();
    if(curr.difference(timeStamps[index]).inSeconds < 2){
      return;
    }
    Future.delayed(const Duration(milliseconds: 500));
    values[index]= 1 - values[index];
    valueNotifiers[index].value = (values[index] == 0) ? Colors.blue : Colors.black;
    timeStamps[index] = new DateTime.now();
  }
}

