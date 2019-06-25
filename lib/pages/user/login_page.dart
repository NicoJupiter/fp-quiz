import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fp_quiz/pages/user/userHome_page.dart';

class Login extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new LoginState();

}

class LoginState extends State<Login>{

  String _email , _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //_isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Color(0xFF373b44),
                    Color(0xFF4286f4)
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
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 300,
                      child: _cardSignIn(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
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
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    labelText: "Enter your current mail"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                validator: (input){
                  if(input.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                    labelText: "Password"
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child:   SizedBox(
                  height: 50,
                  width: 200,
                  child: OutlineButton(
                      child: Text('Login'),
                      onPressed: logIn, //callback when button is clicked
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


  Future<void> logIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(user : user)));
      } catch(e){
        print(e.message);
      }

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
