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
  final Map<String, dynamic> _formData = {
    "title": null,
    "description": null,
    "price": null,
    "image": "assets/food.jpg"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _builTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
      validator: (String value) {
        if (value.isEmpty) {
          return "Title is required";
        }
      },
      onSaved: (String value) {
        _formData["title"] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Description"),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return "Description is required and should be at least 5 characters";
        }
      },
      onSaved: (String value) {
        _formData["description"] = value;
      },
      maxLines: 4,
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price, \$"),
      validator: (String value) {
        if (double.tryParse(value.replaceFirst(RegExp(r','), '.')) == null) {
          return "Price is required and should be a number";
        }
      },
      onSaved: (String value) {
        _formData["price"] =
            double.parse(value.replaceFirst(RegExp(r','), '.'));
      },
      keyboardType: TextInputType.number,
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.addProduct(_formData);
    Navigator.pushReplacementNamed(context, "/products");
  }

  double _getTargetPadding(BuildContext context) {
    final bool isPortraitOrientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetPadding = isPortraitOrientation ? 0 : screenWidth / 8;
    return targetPadding;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).detach();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
              padding:
                  EdgeInsets.symmetric(horizontal: _getTargetPadding(context)),
              children: <Widget>[
                _builTitleTextField(),
                _buildDescriptionTextField(),
                _buildPriceTextField(),
                SizedBox(height: 10.0),
                RaisedButton(
                  textColor: Colors.white,
                  child: Text("SAVE"),
                  onPressed: _submitForm,
                )
              ]),
        ),
      ),
    );
  }
}
