import 'package:flutter/material.dart';
import 'package:fp_quiz/pages/quiz/quiz_page.dart';
import 'package:fp_quiz/ui/TabIndicationPainter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';
import 'package:uuid/uuid.dart';

class QuizRegisterPage extends StatefulWidget {

  @override
  State createState() => new QuizRegisterPageState();
}

class QuizRegisterPageState extends State<QuizRegisterPage> {


  String _firstname , _lastname , _newemail , _newpassword , _currentEmail , _currentPassword;
  PageController _pageController;
  FirebaseDatabaseUtils databaseUtils;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyRegistry = GlobalKey<FormState>();
  Color left = Colors.black;
  Color right = Colors.white;

  bool _isUserSignOnlyMail = false;
  @override
  void initState() {
    super.initState();
    databaseUtils = new FirebaseDatabaseUtils();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Color(0xFF845ec2),
                    Color(0xFFf7418c)
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex : 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: new BorderRadius.circular(100.0),
                            child:   Image.asset("assets/logoFp.png" , height: 150, width: 150,),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                     Align(
                       alignment: Alignment.topCenter,
                       child: Container(
                         width: 300,
                         child: _cardSignIn(),
                       ),
                     ),
                     Align(
                       alignment: Alignment.topCenter,
                       child: Container(
                         width: 300,
                         child: _cardRegistry(),
                       ),
                     ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardRegistry() {
    return Card(
      elevation: 5,
      child: Form(
        key: _formKeyRegistry,
        child: _isUserSignOnlyMail ? _cardRefistryOnlyMailForm() : _cardRegistryFullForm()
      ),
    );
  }

  Widget _cardRegistryFullForm() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom : 20.0 , left: 20.0 , right: 20.0),
          child: TextFormField(
            onSaved: (input) => _firstname = input,
            validator: (input){
              if(input.isEmpty) {
                return 'Pls enter firstname';
              }
            },
            decoration: InputDecoration(
                labelText: "Firstname"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            onSaved: (input) => _lastname = input,
            validator: (input){
              if(input.isEmpty) {
                return 'Pls enter lastname';
              }
            },
            decoration: InputDecoration(
                labelText: "Lastname"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            validator: validateEmail,
            onSaved: (input) => _newemail = input,
            decoration: InputDecoration(
                labelText: "Mail"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            validator: (input){
              if(input.isEmpty) {
                return 'Pls enter your current password';
              }
            },
            onSaved: (input) => _newpassword = input,
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Enter your current password"
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 50,
                width: 100,
                child: OutlineButton(
                    child: Text('Registry'),
                    onPressed: validRegistryForm, //callback when button is clicked
                    borderSide: BorderSide(
                      color: Colors.black, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ),
            SizedBox(
                height: 50,
                width: 150,
                child: OutlineButton(
                    child: Text('Sign in without creating an account'),
                    onPressed: () {
                      setState(() {
                        _isUserSignOnlyMail = true;
                      });
                    },//callback when button is clicked
                    borderSide: BorderSide(
                      color: Colors.black, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardRefistryOnlyMailForm() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            validator: validateEmail,
            onSaved: (input) => _newemail = input,
            decoration: InputDecoration(
                labelText: "Mail"
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child:   SizedBox(
                  height: 50,
                  width: 100,
                  child: OutlineButton(
                      child: Text('Registry'),
                      onPressed: validRegistryForm, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.black, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.8, //width of the border
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child:   SizedBox(
                  height: 50,
                  width: 150,
                  child: OutlineButton(
                      child: Text('I want to create an account'),
                      onPressed: () {
                        setState(() {
                          _isUserSignOnlyMail = false;
                        });
                      },
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
        ),
      ],
    );
  }

  Widget _cardSignIn() {
      return Card(
        elevation: 5,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  validator: validateEmail,
                  onSaved: (input) => _currentEmail = input,
                  decoration: InputDecoration(
                      labelText: "Enter your current mail"
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  validator: (input){
                    if(input.isEmpty) {
                      return 'Pls enter your current password';
                    }
                  },
                  onSaved: (input) => _currentPassword = input,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Enter your current password"
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child:   SizedBox(
                  height: 50,
                  width: 200,
                  child: OutlineButton(
                      child: Text('Login'),
                      onPressed: validSignInForm, //callback when button is clicked
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
          ),
        ),
      );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Future<void> validSignInForm() async{
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _currentEmail, password: _currentPassword);
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(user.uid , user.email)));
      } catch(e){
        print(e.message);
      }

    }
  }

  Future<void> validRegistryForm() async{
    final formState = _formKeyRegistry.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        if(_isUserSignOnlyMail) {
          var uuid = new Uuid();
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(uuid.v4() , _newemail)));
        } else {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _newemail, password: _newpassword);
          databaseUtils.getUser(user.uid).update({
            'firstname': _firstname,
            'lastname': _lastname,
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(user.uid , user.email)));
        }
      } catch(e){
        print(e.message);
      }

    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}