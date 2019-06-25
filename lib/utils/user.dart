import 'package:firebase_database/firebase_database.dart';


class User {

  String _idQuiz;
  String _firstname;
  String _lastname;
  String _email;

  String _score;


  User(this._idQuiz , this._firstname , this._lastname , this._score , this._email);


  String get idQuiz => _idQuiz;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get email => _email;
  String get score => _score;


  User.getListQuiz(DataSnapshot snapshot) {

    _idQuiz = snapshot.key;
   _score = snapshot.value;

  }


  User.getUserInfo(DataSnapshot snapshot) {
    _email = snapshot.value["email"];
    _firstname = snapshot.value["firstname"];
    _lastname = snapshot.value["lastname"];
  }


}