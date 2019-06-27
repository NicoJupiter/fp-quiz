import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_quiz/utils/firebas_database_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fp_quiz/pages/quiz/quizRegister_page.dart';

class ScanQrCodePage extends StatefulWidget {
  @override
  _ScanQrCodePageState createState() => new _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage> {
  String barcode = "";
  String error = "";
  FirebaseDatabaseUtils databaseUtils;

  @override
  initState() {
    super.initState();
    databaseUtils = new FirebaseDatabaseUtils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xFF4e3883),
          title: new Text('QR Code Scanner'),
        ),
        body: new Center(
          child: new Stack(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: scan,
                    child: const Text('Scanner le QR code')
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: barcode != "" ? _buttonAcessToQuiz() : Container(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(error, style: TextStyle(color: Colors.redAccent , fontSize: 20 , fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ),

            ],
          ),
        ));
  }


  Widget _buttonAcessToQuiz() {
    return   SizedBox(
        height: 100,
        width: 200,
        child: OutlineButton(
            child: Text('Acceder au quiz', style: TextStyle(color: Colors.blueAccent , fontSize: 20 , fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizRegisterPage(barcode)),
              );
            }, //callback when button is clicked
            borderSide: BorderSide(
              color: Colors.black, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 1, //width of the border
            ),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0))
        )
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if(barcode != null) {
        databaseUtils.checkLiestQuestion(barcode).once().then((DataSnapshot snapshot) {
          if(snapshot.value != null) {
            setState(() {
              this.barcode = barcode;
              this.error = "";
            });
          } else {
            setState(() {
              this.barcode = "";
              this.error = "Error your Qr code is not for a quiz";
            });
          }
        });
      }
   
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
          this.error = "";
        });
      } else {
        setState(() => this.error = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.error = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.error = 'Unknown error: $e');
    }
  }
}