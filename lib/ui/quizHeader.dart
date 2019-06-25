import 'package:flutter/material.dart';
import 'circleQuiz.dart';


class QuizHeader extends StatefulWidget {


  final String _question;
  final int _questionNumber;

  QuizHeader(this._question , this._questionNumber);

  @override
  State createState() => new QuizHeaderState();


}

class QuizHeaderState extends State<QuizHeader> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/bgQuiz.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top : MediaQuery.of(context).size.height * 0.15,
          child: Container(
            child: Text("Question " + widget._questionNumber.toString(),
                textAlign: TextAlign.center ,
                style: TextStyle(color: Colors.white , fontSize: 40.0 , fontWeight: FontWeight.bold)),
            width: MediaQuery.of(context).size.width,
          ),
        ),
        //Question Text
        Positioned(
          bottom : 0,
          child: Container(
            color: Colors.black45,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        //Question Text
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.075,
          child: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                  child:  Text(widget._question,
                      textAlign: TextAlign.center ,
                      style: TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold)),
            ),
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }
}




