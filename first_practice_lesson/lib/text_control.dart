import 'package:first_practice_lesson/text_output.dart';
import 'package:flutter/material.dart';

class TextControl extends StatefulWidget {
  final String text;

  TextControl({this.text = "Random"});

  @override
  State<StatefulWidget> createState() {
    return _TextControlState();
  }
}

class _TextControlState extends State<TextControl> {
  String _word;

  @override
  void initState() {
    _word = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () {
                    setState(() => _word = "War");
                  },
                  child: Text("Change Text"),
                )),
            TextOutput(_word),
          ],
        ));
  }
}
