import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';

class UserInformation extends StatefulWidget {

  const UserInformation({
    Key key, this.user }) : super(key : key);

  final FirebaseUser user;


  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firstname , _lastname , _email , _password , _currentEmail , _currentPassword;

  double _containerHeight = 600;
  bool _isUserInfoWidget = true;
  bool _isLoading = true;
  FirebaseDatabaseUtils databaseUtils;

  @override
  void initState() {
    super.initState();
    databaseUtils = new FirebaseDatabaseUtils();

    if(_isLoading) {
      databaseUtils.getUser(widget.user.uid).once().then((DataSnapshot snapshot) {
        setState(() {
          _firstname = snapshot.value["firstname"];
          _lastname = snapshot.value["lastname"];
          _isLoading = false;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white70,
        body: _isLoading ? _showCircularProgress() :
        Center(
          child: Card(
            elevation: 5,
            child: Form(
              key: _formKey,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: 300,
                height: _containerHeight,
                child: _isUserInfoWidget ? userInformation() : confirmUpdateCard(),
              ),
            ),
          ),
        )
    );
  }

  /*
  ----------FormValidator-------------
   */
  Future<void> validForm() async{
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        setState(() {
          _containerHeight = 320.0;
          _isUserInfoWidget = false;
        });
      } catch(e){
        print(e.message);
      }

    }
  }

  Future<void> validUser() async{
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _currentEmail, password: _currentPassword);
        user.updateEmail(_email);
        user.updatePassword(_password);

        databaseUtils.getUser(user.uid).update({
          'firstname' : _firstname,
          'lastname' : _lastname
        });
      } catch(e){
        print(e.message);
      }

    }
  }

  /*
    ---------end form validator-------------
   */


  /*
    ---------widgeeeeeeetttttt-------------
   */
  Widget userInformation() {

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
          ),
          child: Image.asset(
            'assets/32M.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            initialValue: _firstname,
            validator: (input){
              if(input.isEmpty) {
                return 'Pls enter firstname';
              }
            },
            onSaved: (input) => _firstname = input,
            decoration: InputDecoration(
                labelText: "Firstname"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            initialValue: _lastname,
            validator: (input){
              if(input.isEmpty) {
                return 'Pls enter lastname';
              }
            },
            onSaved: (input) => _lastname = input,
            decoration: InputDecoration(
                labelText: "Lastname"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            initialValue: widget.user.email,
            validator: validateEmail,
            onSaved: (input) => _email = input,
            decoration: InputDecoration(
                labelText: "Mail"
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
            initialValue: "",
            validator: (input){
              if(input.length < 5) {
                return 'Password must at least be 6 character';
              }
            },
            onSaved: (input) => _password = input,
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Password"
            ),
          ),
        ),
        Center(
          child: RaisedButton(
            onPressed: validForm,
            child: Text("Update"),
          ),
        )
      ],
    );
  }

  Widget confirmUpdateCard() {

    return Column(
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
        Center(
          child: RaisedButton(
            onPressed: validUser,
            child: Text("Confirm update"),
          ),
        )
      ],
    );
  }

  Widget _showCircularProgress(){

    return Center(child: CircularProgressIndicator());

  }


  /*
    ---------end widgeeeeeeetttttt-------------
   */

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

