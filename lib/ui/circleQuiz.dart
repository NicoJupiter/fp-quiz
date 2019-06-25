import 'package:flutter/material.dart';


class CircleQuiz extends StatelessWidget  {


  final color;

  CircleQuiz(this.color);


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 25.0,
      height: 25.0,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}