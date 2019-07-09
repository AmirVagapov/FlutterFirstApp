import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl, this.description, this.price);

  Widget _buildAddressPriceRow() {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Union Square, San Francisco",
                    style: TextStyle(fontFamily: "Oswald", color: Colors.grey),
                  ),
                  Container(
                    child: Text("|"),
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                  Text(
                    "\$$price",
                    style: TextStyle(fontFamily: "Oswald", color: Colors.grey),
                  )
                ],
              );
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
            body: SingleChildScrollView(
                child: Column(children: [
              Image.asset(imageUrl),
              SizedBox(height: 10.0),
              TitleDefault(title),
              SizedBox(height: 10.0),
              _buildAddressPriceRow(),
              Container(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10.0),
              ),
            ]))));
  }
}
