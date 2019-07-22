import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/ui_elements/network_image_with_placeholder.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

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
          title: Text(product.title),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            NetworkImageWithPlaceholder(product.image),
            SizedBox(height: 10.0),
            TitleDefault(product.title),
            SizedBox(height: 10.0),
            _buildAddressPriceRow(product.price),
            Container(
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAddressPriceRow(double price) {
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
}
