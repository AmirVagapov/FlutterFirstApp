import 'package:flutter/material.dart';

final _androidTheme = ThemeData(
  // buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlue),
  primarySwatch: Colors.deepOrange,
  accentColor: Colors.purple,
  brightness: Brightness.light,
  buttonColor: Colors.purple,
);

final _iosTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.blue,
  brightness: Brightness.light,
  buttonColor: Colors.blue,
);

ThemeData getSpecificThemeData(BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return _iosTheme;
  } else {
    return _androidTheme;
  }
}
