import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/pages/products.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentification"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Login"),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
    );
  }
}
