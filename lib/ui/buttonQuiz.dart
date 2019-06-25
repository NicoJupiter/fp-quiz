import 'package:flutter/material.dart';

class ButtonQuiz extends StatelessWidget{

  final String reply;

  final VoidCallback _onTap;

  ButtonQuiz(this.reply , this._onTap);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
          height: 50,
          width: 300,
          child:OutlineButton(
              child: Text(reply),
              onPressed: () => _onTap(),//callback when button is clicked
              borderSide: BorderSide(
                color: Colors.black, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: 0.8, //width of the border
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          )
      ),
    );
  }



}