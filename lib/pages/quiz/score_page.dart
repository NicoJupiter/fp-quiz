import 'package:flutter/material.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';

import '../landing_page.dart';

class ScorePage extends StatelessWidget {

  final int score;
  final int totalQuestions;
  final String timer;
  final String userId;
  final String userMail;
  final String selectedQuiz;
  final FirebaseDatabaseUtils databaseUtils = new FirebaseDatabaseUtils();
  ScorePage(this.score, this.totalQuestions , this.timer , this.userId , this.userMail , this.selectedQuiz);

  @override
  Widget build(BuildContext context) {

    var timeFinal = (parseDuration(timer).inSeconds / 60);
    var finalScore = (score / timeFinal);

    databaseUtils.getQuiz(userId).update({
     selectedQuiz : finalScore.toStringAsFixed(2)
    });

    databaseUtils.getUserMail(userId , selectedQuiz).update({
      'mail' : userMail
    });

    return new Material(
        color: Colors.blueAccent,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Score total : ", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0),),
            new Text(finalScore.toStringAsFixed(2), style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0)),
            new IconButton(
                icon: new Icon(Icons.arrow_right),
                color: Colors.white,
                iconSize: 50.0,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new LandingPage()), (Route route) => route == null)
            )
          ],
        )
    );
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }

    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}