import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerPge extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("User page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: new QrImage(
              data: "1234567890",
              size: 200.0,
            ),
          )
        ],
      ),
    );
  }
}