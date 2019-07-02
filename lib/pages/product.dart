import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  _showWarningDialog(BuildContext context) {
    showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("This action can't be undone!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("DELETE"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                    )
                  ]);
            })
        // также  можно использовать
        //     .then((bool value) {
        //   if (value == true) {
        //     Navigator.pop(context, value);
        //   }
        // })
        ;
  }

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
                        onPressed: () => _showWarningDialog(context),
                      ))
                ])));
  }
}
