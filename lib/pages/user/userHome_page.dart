import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fp_quiz/pages/user/userInformation_page.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fp_quiz/utils/user.dart';
import 'package:fp_quiz/pages/user/quizDetail_page.dart';
import 'package:fp_quiz/pages/user/qrScanner_page.dart';


class UserHome extends StatefulWidget {

  const UserHome({
    Key key, this.user }) : super(key : key);

  final FirebaseUser user;

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  FirebaseDatabaseUtils databaseUtils;
  bool _anchorToBottom = false;
  User userData;
  bool _loading = true;


  @override
  void initState() {
    super.initState();
    databaseUtils = new FirebaseDatabaseUtils();

  }

  @override
  Widget build(BuildContext context) {
    if(_loading) {
      databaseUtils.getUser(widget.user.uid).once().then((DataSnapshot snapshot) {
        userData = User.getUserInfo(snapshot);

        setState(() {
          _loading = false;
        });
      });

    }
    Widget _childWidget;

    _loading ? _childWidget = _showCircularProgress(_loading) :
    _childWidget = Column(
      children: <Widget>[
        Flexible(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bgUserPage.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                     Padding(
                       padding: EdgeInsets.only(top: 20.0),
                       child: Container(
                           width: 100.0,
                           height: 100.0,
                           decoration: new BoxDecoration(
                               shape: BoxShape.circle,
                               image: new DecorationImage(
                                 fit: BoxFit.fill,
                                 image: AssetImage('assets/32M.png'),
                               )
                           )),
                     ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text("Hey welcome",
                            style: TextStyle(color: Colors.white , fontSize: 15.0 , fontStyle: FontStyle.italic)),
                      ),

                      Text(userData.firstname + " " + userData.lastname,
                          style: TextStyle(color: Colors.white , fontSize: 20.0 )),
                    ],
                  ),
                )
              ],
            )
        ),
        Flexible(
          flex: 4,
          child: FirebaseAnimatedList(

            key: new ValueKey<bool>(_anchorToBottom),
            query: databaseUtils.getQuiz(widget.user.uid),
            reverse: _anchorToBottom,
            sort: _anchorToBottom
                ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                : null,

            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return new SizeTransition(
                sizeFactor: animation,
                child: showListQuiz(snapshot , index),
              );
            },
          ),
        )
      ],
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4e3883),
          title: Text("User page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {  Navigator.push(context, MaterialPageRoute(builder: (context) => UserInformation(user : widget.user)));},
            )
          ],
        ),
      body: _childWidget
    );

  }
  Widget showListQuiz(DataSnapshot res , index) {

    int realIndex = index+1;
    User userQuiz = User.getListQuiz(res);

    var item = InkWell(

      onTap:() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizDetail(widget.user.uid ,  userQuiz.idQuiz , userQuiz.score.toString())),
        );
      },
      child: Card(
        elevation: 2.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFffddcc)),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.black))),
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('quiz')
                      .child(userQuiz.idQuiz)
                      .child('winner')
                      .onValue,
                    builder:
                    (BuildContext context, AsyncSnapshot<Event> event) {
                      if (!event.hasData)
                        return IconButton(
                          icon: Icon(Icons.cake),
                          onPressed: null,
                        );
                      bool isWinner = false;
                      if(event.data.snapshot.value == widget.user.uid)
                        isWinner = true;

                      return IconButton(
                          icon: Icon(Icons.cake),
                          color: isWinner ? Colors.greenAccent : Colors.redAccent,
                          onPressed: () => {
                        isWinner ? Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QrScannerPge(userQuiz.idQuiz)),
                      ) : null
                          }
                      );
                    },
                    
                )
              ),
              title: Text(
                userQuiz.idQuiz,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle:
              Text("Score : "+userQuiz.score, style: TextStyle(color: Colors.black)),

              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0)
          ),
        ),
      ),
    );

    return item;
  }
}



Widget _showCircularProgress(_isLoading){
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  } return Container(height: 0.0, width: 0.0,);

}


