import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

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

  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentification"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).detach();
        },
        child: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: _getTargetWidth(context),
                child: Form(
                  key: _authFormKey,
                  child: Column(children: [
                    SizedBox(height: 10.0),
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 10.0),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return RaisedButton(
                          textColor: Colors.white,
                          child: Text("Login"),
                          onPressed: () => _acceptForm(model.login),
                        );
                      },
                    )
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        fit: BoxFit.cover,
        image: AssetImage("assets/background.jpg"));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: _buildTextFieldInputDecoration("Enter your email"),
      validator: (String value) {
        final bool isValidEmail = value.length < 5 ||
            !value.contains("@") ||
            !value.contains(".") ||
            value.split('.').last.isEmpty;
        if (isValidEmail) {
          return "Invalid email";
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: _buildTextFieldInputDecoration("Enter password"),
      validator: (String value) {
        if (value.length < 5) {
          return "Password should contains at least 5 character";
        }
      },
      onSaved: (String value) {
        _password = value;
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

  void _acceptForm(Function login) {
    if (!_authFormKey.currentState.validate() || !_acceptTerms) return;
    _authFormKey.currentState.save();
    login(_email, _password);
    Navigator.pushReplacementNamed(context, '/products');
  }

  double _getTargetWidth(BuildContext context) {
    final bool isPortraitOrientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    return isPortraitOrientation ? screenWidth : screenWidth * 0.6;
  }
}
