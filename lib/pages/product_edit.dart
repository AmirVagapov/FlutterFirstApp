import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/widgets/form_inputs/location.dart';
import 'package:flutter_course/widgets/ui_elements/dialog_error.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../widgets/form_inputs/location.dart';
import '../scoped-models/main.dart';

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
    "image": "assets/food.jpg",
    "loc_data": null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.selectedProductIndex == -1
            ? _buildContentBody()
            : _buildPageWithAppBar(model.selectedProduct);
      },
    );
  }

  Widget _buildContentBody([Product product]) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: _getTargetPadding(context), vertical: 10.0),
            children: <Widget>[
              _builTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10.0),
              LocationForm(_setLocation),
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

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                textColor: Colors.white,
                child: Text("SAVE"),
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  void _setLocation(LocationData locData) {
      _formData["loc_data"] = locData;
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function selectProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      _submitAction(context, selectProduct, addProduct);
    } else {
      _submitAction(context, selectProduct, updateProduct);
    }
  }

  void _submitAction(
      BuildContext context, Function selectProduct, Function saveProduct) {
    saveProduct(_formData["title"], _formData["description"],
            _formData["image"], _formData["price"], _formData["loc_data"])
        .then((bool success) {
      success
          ? _openProducts(context, selectProduct)
          : _showErrorDialog(context);
    });
  }

  void _openProducts(BuildContext context, Function selectProduct) {
    Navigator.pushReplacementNamed(context, "/")
        .then((_) => selectProduct(null));
  }

  void _showErrorDialog(BuildContext context) {
    ErrorDialog().show(context);
  }

  double _getTargetPadding(BuildContext context) {
    final bool isPortraitOrientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetPadding = isPortraitOrientation ? 0 : screenWidth / 8;
    return targetPadding;
  }
}
