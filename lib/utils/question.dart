import 'package:firebase_database/firebase_database.dart';


class Question {

   String _question;
   String _anwser;
   String _option1;
   String _option2;
   String _option3;
   String _option4;
   String _quizDetail;


  Question(this._question , this._anwser , this._option1 , this._option2 , this._option3 , this._option4 , this._quizDetail);


  String get question => _question;
  String get anwser => _anwser;
  String get option1 => _option1;
  String get option2 => _option2;
  String get option3 => _option3;
  String get option4 => _option4;
  String get quizDetail => _quizDetail;

   Question.getQuestionFromSnapshot(DataSnapshot snapshot) {

      _question = snapshot.value["sujet"];
      _anwser = snapshot.value["reponse"];
      _option1 = snapshot.value["choix1"];
      _option2 = snapshot.value["choix2"];
      _option3 = snapshot.value["choix3"];
      _option4 = snapshot.value["choix4"];
      _quizDetail = snapshot.value["details"];
   }

}