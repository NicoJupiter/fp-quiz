import 'package:flutter/material.dart';
import 'package:fp_quiz/pages/quiz/scanQrCode_page.dart';
import 'package:fp_quiz/pages/user/login_page.dart';



class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    colorFilter: new ColorFilter.mode(Colors.deepPurple.withOpacity(0.5), BlendMode.softLight),
                    image: new AssetImage("assets/bg1.jpg"),
                    fit: BoxFit.cover
                )
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: new BorderRadius.circular(150.0),
                        child:   Image.asset("assets/logoFp.png" , height: 250, width: 250,),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 50,
                        width: 250,
                        child: new OutlineButton(
                            child: new Text("ACCEDER AU QUIZ",
                              style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ScanQrCodePage()));
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: new OutlineButton(
                          child: new Text("ACCEDER A VOTRE PROFIL",
                            style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }


}