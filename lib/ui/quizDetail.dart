import 'package:flutter/material.dart';

import '../utils/question.dart';

class QuizDetail extends StatelessWidget {

 final Question currentQuestion;
 final String quizDetail;
 final String selectedOption;
 final bool isCorrect;
 final  VoidCallback _onTap;


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
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child:   SizedBox(
                height: 50,
                width: 200,
                child: OutlineButton(
                    child: Text('Suivant'),
                    onPressed: () => _onTap(),
                    borderSide: BorderSide(
                      color: Colors.black, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ),
          ),
        ],
    );

  }


}
