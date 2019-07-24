import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorDialog {
  final String titleText;
  final String contentText;

  ErrorDialog(
      {this.titleText = "Something went wrong",
      this.contentText = "Please try again"});

  show(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(contentText),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: (() {
                  Navigator.pop(context);
                }),
              ),
            ],
          );
        });
    ;
  }
}
