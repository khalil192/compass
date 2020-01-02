import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'path finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Grid(),
    );
  }
}

class Grid extends StatefulWidget {
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('path finder'),
          ),
          body:Center(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                height: 1000,
                width: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    for(int i=0;i<40;i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for(int i=0;i<70;i++)
                          Cell(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
          // Container(
          //   color: Colors.orange,
          //   width: 1100,
          //   height: 2000,
          //     child: Align(
          //           alignment: Alignment.bottomCenter,
          //           child: GridView.count(
          //         crossAxisCount: 50,
          //           children: <Widget>[
          //             for(int i=0;i<500;i++)
          //               Cell(),
          //           ],
          //       ),
          //   ),
          // ),
      // ),
    );
  }
}

class Cell extends StatefulWidget {
  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    Color currColor = Colors.blue;
    return
        // borderOnForeground: true,
         Padding(
          padding: const EdgeInsets.all(0.5),
          child: Container(
        color: currColor,
        width: 15,
        height: 15,
        ),
        // ),
         );
  }
}
