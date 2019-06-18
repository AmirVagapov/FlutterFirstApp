import 'package:first_practice_lesson/text_control.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.teal, buttonColor: Colors.tealAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text("TextOutputApp"),
        ),
        body: TextControl(text: "Peace"),
      ),
    );
  }
}
