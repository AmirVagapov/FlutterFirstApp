import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    "title": null,
    "description": null,
    "price": null,
    "image": "assets/food.jpg"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _builTitleTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
      initialValue: product == null ? '' : product.title,
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

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Description"),
      initialValue: product == null ? "" : product.description,
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

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price, \$"),
      initialValue: product == null ? "" : product.price.toString(),
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

  void _submitForm(Function addProduct, Function updateProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      addProduct(Product(
          title: _formData["title"],
          description: _formData["description"],
          price: _formData["price"],
          image: _formData["image"]));
    } else {
      updateProduct(Product(
          title: _formData["title"],
          description: _formData["description"],
          price: _formData["price"],
          image: _formData["image"]));
    }
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
      child: _buildPage(),
    );
  }

  Widget _buildPage() {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return model.selectedProductIndex == null
            ? _buildContentBody()
            : _buildPageWithAppBar(model.selectedProduct);
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return RaisedButton(
          textColor: Colors.white,
          child: Text("SAVE"),
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,
              model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildContentBody([Product product]) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
            padding:
                EdgeInsets.symmetric(horizontal: _getTargetPadding(context)),
            children: <Widget>[
              _builTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10.0),
              _buildSubmitButton()
            ]),
      ),
    );
  }

  Widget _buildPageWithAppBar(Product product) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: _buildContentBody(product),
    );
  }
}
