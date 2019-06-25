import 'package:flutter/material.dart';
import 'package:fp_quiz/ui/quizHeader.dart';
import 'package:fp_quiz/ui/quizDetail.dart';
import 'package:fp_quiz/ui/buttonQuiz.dart';
import 'package:fp_quiz/utils/question.dart';
import 'package:fp_quiz/utils/quiz.dart';

import 'score_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';

import 'dart:collection';

class QuizPage extends StatefulWidget {

  QuizPage(this.userid , this.userMail);

  final String userid;
  final String userMail;

  @override
  State createState() => new QuizPageState();

}

class QuizPageState extends State<QuizPage> {

  QuizPageState() {
    databaseUtils = new FirebaseDatabaseUtils();
    databaseUtils.getListQuestion().once().then((DataSnapshot snapshot) {

      SplayTreeMap<dynamic, dynamic> values = new SplayTreeMap<dynamic, dynamic>.from(snapshot.value);

      values.forEach((key,values) {
        listQuestion.add(new Question(values["sujet"] , values["reponse"], values["choix1"], values["choix2"], values["choix3"], values["choix4"], values["details"]));
      });

      setState(() {
       quiz = new Quiz(listQuestion);
        currentQuestion = quiz.nextQuestion;
        questionText = currentQuestion.question;
        questionNumber = quiz.questionNumber;

        optionOne = currentQuestion.option1;
        optionTwo = currentQuestion.option2;
        optionThree = currentQuestion.option3;
        optionFour = currentQuestion.option4;
        detailQuestion = currentQuestion.quizDetail;
        _isLoading = false;
      });
    });
  }

  Stopwatch stopwatch = new Stopwatch();

  Question currentQuestion;
  Quiz quiz;
  bool _isLoading = true;

  FirebaseDatabaseUtils databaseUtils;
  String questionText;
  String optionOne;
  String optionTwo;
  String optionThree;
  String optionFour;
  String selectedOption;
  String detailQuestion;
  List<Question> listQuestion = [];
  int questionNumber;
  bool isCorrect;
  bool isDisplayDetail = false;

  void handleAwnser(String anwser, questionNumber, time) {

    databaseUtils.getTimer(widget.userid).once().then((DataSnapshot snapshot) {

      databaseUtils.getUserResponse(widget.userid).update({
        'reponse'+questionNumber.toString() : anwser,
      });

      databaseUtils.getTimer(widget.userid).update({
        'currentTime' : time.toString()
      });

    });

    isCorrect = (currentQuestion.anwser == anwser);
    quiz.awnser(isCorrect);
    this.setState(() {
      selectedOption = anwser;
      isDisplayDetail = true;
    });

  }


  @override
  void iniState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    stopwatch.start();

    Widget _childWidget;
     _isLoading ?
     _childWidget =  _showCircularProgress(_isLoading) :
     _childWidget =  Column(
       children: <Widget>[

         Flexible(
           flex: 3,
           child: QuizHeader(questionText , questionNumber),
         ),

         Flexible(
           flex: 3,
           child: isDisplayDetail == true ? QuizDetail(
               currentQuestion , isCorrect , detailQuestion , selectedOption,
                   () {
                 if (quiz.length == questionNumber) {
                   databaseUtils.getTimer(widget.userid).once().then((DataSnapshot snapshot) {
                     Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length , snapshot.value["currentTime"] , widget.userid , widget.userMail)), (Route route) => route == null);
                     return;
                   });
                 } else {
                   currentQuestion = quiz.nextQuestion;
                   this.setState(() {
                     isDisplayDetail = false;
                     questionText = currentQuestion.question;
                     questionNumber = quiz.questionNumber;
                     optionOne = currentQuestion.option1;
                     optionTwo = currentQuestion.option2;
                     optionThree = currentQuestion.option3;
                     optionFour = currentQuestion.option4;
                     detailQuestion = currentQuestion.quizDetail;
                   });
                 }
               }
           ) :
           Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 ButtonQuiz(optionOne , () => handleAwnser(optionOne , questionNumber , stopwatch.elapsed)),
                 ButtonQuiz(optionTwo , () => handleAwnser(optionTwo, questionNumber, stopwatch.elapsed)),
                 ButtonQuiz(optionThree , () => handleAwnser(optionThree, questionNumber, stopwatch.elapsed)),
                 ButtonQuiz(optionFour , () => handleAwnser(optionFour, questionNumber, stopwatch.elapsed)),
               ],
             ),
           ),
         ),

       ],
     );

     return Scaffold(
       body: _childWidget,
     );
  }
}

Widget _showCircularProgress(_isLoading){
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  } return Container(height: 0.0, width: 0.0,);

}
