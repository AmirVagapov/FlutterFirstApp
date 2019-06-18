import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_course/product_manager.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         // buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlue),
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.purple,
          brightness: Brightness.light),
      home: Scaffold(
        appBar: AppBar(
          title: Text('EasyList'),
        ),
        body: ProductManager(startingProduct: 'Food tester'),
      ),
    );
  }
}
