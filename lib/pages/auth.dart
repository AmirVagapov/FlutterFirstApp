import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/shared/adaptive_widgets/adaptive_button.dart';
import 'package:flutter_course/widgets/ui_elements/dialog_error.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/auth_mode.dart';
import '../shared/adaptive_widgets/adaptive_progress.dart';
import '../shared/adaptive_widgets/ui_utils.dart';
import '../shared/adaptive_widgets/adaptive_switch.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  String _email;
  String _password;
  bool _acceptTerms = false;
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: getSpecificElevation(context),
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
                    _buildPasswordConfirmTextField(),
                    SizedBox(height: 10.0),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10.0),
                    _buildConfirmButton(),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: AdaptiveProdgressIndicator())
                            : AdaptiveButtonWidget(
                                textColor: Colors.white,
                                child: Text(_authMode == AuthMode.Login
                                    ? "Login"
                                    : "Signup"),
                                onPressed: () =>
                                    _acceptForm(model.authenticate),
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
            value.split('.').last.isEmpty ||
            value.split("@").last.startsWith(".");
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
      controller: _passwordController,
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

  Widget _buildPasswordConfirmTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            TextFormField(
              obscureText: true,
              decoration: _buildTextFieldInputDecoration("Confirm Password"),
              validator: (String value) {
                if (_passwordController.text != value &&
                    _authMode == AuthMode.Signup) {
                  return "Password do not match";
                }
              },
              onSaved: (String value) {
                if (_authMode == AuthMode.Signup) {
                  _password = value;
                }
              },
            ),
          ],
        ),
      ),
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
        child: AdaptiveSwitch(
            _acceptTerms, "Accept Terms and Privacy Policy", _setAcceptTerms));
  }

  void _setAcceptTerms(bool value) {
    setState(() => {_acceptTerms = value});
  }

  Widget _buildConfirmButton() {
    return FlatButton(
      child:
          Text("Switch to ${_authMode == AuthMode.Login ? "Signup" : "Login"}"),
      onPressed: () {
        if (_authMode == AuthMode.Login) {
          setState(() {
            _authMode = AuthMode.Signup;
          });
          _controller.forward();
        } else {
          setState(() {
            _authMode = AuthMode.Login;
          });
          _controller.reverse();
        }
      },
    );
  }

  void _acceptForm(Function authenticate) async {
    if (!_authFormKey.currentState.validate() || !_acceptTerms) return;
    _authFormKey.currentState.save();
    Map<String, dynamic> authInformation =
        await authenticate(_email, _password, _authMode);

    if (!authInformation["success"]) {
      ErrorDialog(
              titleText: "An error occured",
              contentText: authInformation["message"])
          .show(context);
    }
  }

  double _getTargetWidth(BuildContext context) {
    final bool isPortraitOrientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    return isPortraitOrientation ? screenWidth : screenWidth * 0.6;
  }
}
