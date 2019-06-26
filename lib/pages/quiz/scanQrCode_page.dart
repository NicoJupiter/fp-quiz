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
          title: new Text('QR Code Scanner'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: barcode != "" ? _buttonAcessToQuiz() : Container(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(error),
              )
              ,
            ],
          ),
        ));
  }


  Widget _buttonAcessToQuiz() {
    return   SizedBox(
        height: 50,
        width: 100,
        child: OutlineButton(
            child: Text('Acceder au quiz'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizRegisterPage(barcode)),
              );
            }, //callback when button is clicked
            borderSide: BorderSide(
              color: Colors.black, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 0.8, //width of the border
            ),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
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