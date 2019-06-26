import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fp_quiz/utils/question.dart';
import 'dart:collection';

class QuizDetail extends StatefulWidget {


  QuizDetail(this.userId , this.quizIndex , this.score);
  final String userId;
  final String quizIndex;
  final String score;


  @override
  State createState() => new QuizDetailState();

}

class QuizDetailState extends State<QuizDetail> {

  String selectedQuiz;

  @override
  initState() {
    super.initState();
    setState(() {
      selectedQuiz = "quiz"+widget.quizIndex;
    });
  }

   FirebaseDatabaseUtils databaseUtils = new FirebaseDatabaseUtils();

  final bool _anchorToBottom = false;
  bool _isLoading = true;
  List<String> userResponse = [];
  @override
  Widget build(BuildContext context) {


    if(_isLoading) {
      databaseUtils.getUserResponse(widget.userId , selectedQuiz).once().then((DataSnapshot snapshot) {
        SplayTreeMap<dynamic, dynamic> values = new SplayTreeMap<dynamic, dynamic>.from(snapshot.value);

        values.forEach((key,value) {
          userResponse.add(value);
        });

        setState(() {
          _isLoading = false;
        });
      });
    }


    Widget _childWidget;

    _isLoading == true ? _childWidget = _showCircularProgress(_isLoading)
    : _childWidget = Column(
      children: <Widget>[
        Flexible (
          flex: 1,
          child: Center(
            child: Text("Votre score : "+widget.score , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),),
          ),
        ),
        Flexible(
          flex: 5,
          child: FirebaseAnimatedList(
            // TODO changer la variable
            key: new ValueKey<bool>(_anchorToBottom),
            query: databaseUtils.getListQuestion(selectedQuiz),
            reverse: _anchorToBottom,
            sort: _anchorToBottom
                ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                : null,

            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return new SizeTransition(
                sizeFactor: animation,
                child: questionBlock(context , snapshot, index, userResponse[index])
              );
            },
          ),
        )
      ],
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4e3883),
        title: Text("Détails du quiz"),
      ),
      body: _childWidget
    );
  }
}

Widget questionBlock(BuildContext context , DataSnapshot snapshot , int index , String userResponse) {


  var newIndex = index+1;
  Question question = Question.getQuestionFromSnapshot(snapshot);
  bool _isCorrectResponse;
  userResponse == question.anwser ? _isCorrectResponse = true : _isCorrectResponse = false;
  var item =   Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: _isCorrectResponse ? Colors.greenAccent : Colors.redAccent,
        border: Border(bottom: BorderSide(width: 3.0 , color: Colors.white))),
    child:  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0 , horizontal: 5.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text("Question : " + newIndex.toString() + " " +question.question),
          ),
          Text("1." + question.option1),
          Text("2." + question.option2),
          Text("3." + question.option3),
          Text("4." + question.option4),
          Text(_isCorrectResponse ? "Your anwser : " + question.anwser : "Your anwser : " + userResponse +" Correct anwser : " + question.anwser),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text("Détails : " + question.quizDetail),
          ),
        ],
      ),
    ),
  );
  return item;
}

Widget _showCircularProgress(_isLoading){
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  } return Container(height: 0.0, width: 0.0,);

}