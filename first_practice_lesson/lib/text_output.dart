import 'package:flutter/material.dart';

class TextOutput extends StatelessWidget {
  final String _text;

  TextOutput(this._text);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: Text(_text),
    );
  }
}
