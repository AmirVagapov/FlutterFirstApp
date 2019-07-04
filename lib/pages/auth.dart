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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Authentification"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: AssetImage("assets/background.jpg"))),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
                child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 10.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.white)),
                      labelText: "Enter your email",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7)),
                  onChanged: (String value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.grey)),
                      labelText: "Enter password",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7)),
                  onChanged: (String value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                DecoratedBox(
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
                    )),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Login"),
                  onPressed: () {
                    if (_email == null || _password == null || !_acceptTerms) {
                      return;
                    }
                    Navigator.pushReplacementNamed(context, '/products');
                  },
                ),
              ]),
            ))));
  }
}
