import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorDialog {
  show(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Something went wrong"),
            content: Text("Please try again"),
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
