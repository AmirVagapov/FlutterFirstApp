import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_course/pages/home_page.dart';

import 'package:flutter_course/product_manager.dart';

main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          // buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlue),
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.purple,
          brightness: Brightness.light),
      home: HomePage(),
    );
  }
}
