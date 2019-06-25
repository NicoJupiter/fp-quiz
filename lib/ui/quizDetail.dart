import 'package:flutter/material.dart';

import '../utils/question.dart';

class QuizDetail extends StatelessWidget {

  Question currentQuestion;
  String quizDetail;
  String selectedOption;
  bool isCorrect;
  final VoidCallback _onTap;


  QuizDetail(this.currentQuestion  , this.isCorrect , this.quizDetail , this.selectedOption ,this._onTap);

  @override
  Widget build(BuildContext context){

    print(selectedOption);

    return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.060,
                color: isCorrect == true ? Colors.greenAccent : Colors.redAccent,
              ),
              Positioned(
                top : MediaQuery.of(context).size.height * 0.020,
                left:  MediaQuery.of(context).size.width * 0.020,
                child: Text(
                  "Votre réponse", style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                top : MediaQuery.of(context).size.height * 0.020,
                left:  MediaQuery.of(context).size.width * 0.50,
                child: Text(
                  selectedOption, style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          !isCorrect ? Padding(
            padding : EdgeInsets.only(top :  MediaQuery.of(context).size.height * 0.01),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.060,
                  color: Colors.greenAccent,
                ),
                Positioned(
                  top : MediaQuery.of(context).size.height * 0.020,
                  left:  MediaQuery.of(context).size.width * 0.020,
                  child: Text(
                    "Réponse correct", style: TextStyle(color: Colors.white),
                  ),
                ),
                Positioned(
                  top : MediaQuery.of(context).size.height * 0.020,
                  left:  MediaQuery.of(context).size.width * 0.50,
                  child: Text(
                    currentQuestion.anwser, style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ) : Container(height:0),

          Padding(
            padding : EdgeInsets.only(top :  MediaQuery.of(context).size.height * 0.05),
            child: Text(quizDetail,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),),
          ),

          Padding(
              padding: EdgeInsets.symmetric(vertical :  MediaQuery.of(context).size.height * 0.05 , horizontal: MediaQuery.of(context).size.height * 0.15 ),
              child: ButtonTheme(
                height: MediaQuery.of(context).size.height * 0.055,
                child: RaisedButton(

                    color: Colors.white30,
                    child: Text("Suivant"),
                    onPressed: () => _onTap(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                ),
              )
          ),

        ],
    );

  }


}
