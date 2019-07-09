import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;
  bool _acceptTerms = false;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        fit: BoxFit.cover,
        image: AssetImage("assets/background.jpg"));
  }

  Widget _buildEmailTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: _buildTextFieldInputDecoration("Enter your email"),
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      obscureText: true,
      decoration: _buildTextFieldInputDecoration("Enter password"),
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  InputDecoration _buildTextFieldInputDecoration(String labelText) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey)),
        labelText: labelText,
        filled: true,
        fillColor: Colors.white.withOpacity(0.7));
  }

  Widget _buildAcceptSwitch() {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Colors.grey, width: 1.0)),
        child: SwitchListTile(
          title: Text("Accept Terms and Pricay Policy"),
          value: _acceptTerms,
          onChanged: (bool value) {
            setState(() {
              _acceptTerms = value;
            });
          },
        ));
  }

  void _acceptForm() {
    if (_email == null || _password == null || !_acceptTerms) {
      return;
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  double _getTargetWidth(BuildContext context) {
    final bool isPortraitOrientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    return isPortraitOrientation ? screenWidth : screenWidth * 0.6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentification"),
        ),
        body: Container(
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Container(
              width: _getTargetWidth(context),
              child: Column(children: [
                SizedBox(height: 10.0),
                _buildEmailTextField(),
                SizedBox(height: 10.0),
                _buildPasswordTextField(),
                SizedBox(height: 10.0),
                _buildAcceptSwitch(),
                SizedBox(height: 10.0),
                RaisedButton(
                  textColor: Colors.white,
                  child: Text("Login"),
                  onPressed: _acceptForm,
                ),
              ]),
            )))));
  }
}
