import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoadingScreenState();
  }
}

class LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(milliseconds: 2500);
    return new Timer(duration, route);
  }

  route() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Center(
            child:
            AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child:
                Container(
                  height: 150,
                  width: 150,
                  child:
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 30,
                    shadowColor: Colors.lightBlue,
                    color: Colors.blue,
                    child:
                    LoadingBouncingGrid.square(
                      borderColor: Colors.lightBlueAccent,
                      borderSize: 3.0,
                      size: 80.0,
                      backgroundColor: Colors.white,
                      duration: Duration(milliseconds: 1500),
                    ),
                  ),
                )
            )
        )
    );

  }

}
