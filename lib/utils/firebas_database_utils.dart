import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'user.dart';

class FirebaseDatabaseUtils {


  DatabaseReference _databaseReference;


  FirebaseDatabase database = new FirebaseDatabase();
  DatabaseError error;

  static final FirebaseDatabaseUtils _instance =
  new FirebaseDatabaseUtils.internal();

  FirebaseDatabaseUtils.internal();

  factory FirebaseDatabaseUtils() {
    return _instance;
  }

  DatabaseReference getUser(userId) {
    _databaseReference = database.reference().child('users/'+userId+'/information');

    return _databaseReference;
  }

  DatabaseReference getQuiz(userId) {
    _databaseReference = database.reference().child('users/'+userId+'/listQuiz');

    return _databaseReference;
  }

  DatabaseReference getWinner(index) {
    _databaseReference = database.reference().child('quiz/quiz'+index+'/winner');

    return _databaseReference;
  }

  DatabaseReference getListQuestion() {
    _databaseReference = database.reference().child("quiz/quiz1/questions");

    return _databaseReference;
  }

  DatabaseReference getUserResponse(userId) {
    _databaseReference = database.reference().child("quiz/quiz1/participants/"+userId+"/response");

    return _databaseReference;
  }

  DatabaseReference getTimer(userId) {
    _databaseReference = database.reference().child("quiz/quiz1/participants/"+userId+"/timer");

    return _databaseReference;
  }

  DatabaseReference getUserMail(userId) {
    _databaseReference = database.reference().child("quiz/quiz1/participants/"+userId+"/mail");

    return _databaseReference;
  }




}