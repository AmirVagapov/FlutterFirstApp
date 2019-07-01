import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("On back pressed");
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imageUrl),
                  Container(padding: EdgeInsets.all(10.0), child: Text(title)),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("DELETE"),
                        onPressed: () => Navigator.pop(context, true),
                      ))
                ])));
  }
}