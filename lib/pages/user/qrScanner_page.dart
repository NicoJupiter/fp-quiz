import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerPge extends StatelessWidget {

  QrScannerPge(this.quizId);

  final String quizId;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4e3883),
        title: Text("Obtenir son gain"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: new QrImage(
              data: quizId,
              size: 200.0,
            ),
          )
        ],
      ),
    );
  }
}