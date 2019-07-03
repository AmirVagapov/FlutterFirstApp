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
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: ListView(children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Enter your email"),
                  onChanged: (String value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Enter password"),
                  onChanged: (String value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text("Accept Terms and Pricay Policy"),
                  value: _acceptTerms,
                  onChanged: (bool value) {
                    setState(() {
                      _acceptTerms = value;
                    });
                  },
                ),
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
            )));
  }
}
