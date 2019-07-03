import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "Product Title"),
            onChanged: (String value) {
              setState(() {
                _titleValue = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Product Description"),
            onChanged: (String value) {
              setState(() {
                _descriptionValue = value;
              });
            },
            maxLines: 4,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Product Price, \$"),
            onChanged: (String value) {
              setState(() {
                _priceValue = double.parse(value);
              });
            },
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text("SAVE"),
            onPressed: () {
              final Map<String, dynamic> product = {
                "title": _titleValue,
                "description": _descriptionValue,
                "price": _priceValue,
                "image": "assets/food.jpg"
              };
              widget.addProduct(product);
              Navigator.pushReplacementNamed(context, "/products");
            },
          )
        ]));
  }
}
