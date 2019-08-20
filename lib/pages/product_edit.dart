import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/widgets/form_inputs/image.dart';
import 'package:flutter_course/widgets/form_inputs/location.dart';
import 'package:flutter_course/widgets/ui_elements/dialog_error.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../widgets/form_inputs/location.dart';
import '../scoped-models/main.dart';
import 'dart:io';
import '../shared/adaptive_widgets/adaptive_progress.dart';
import '../shared/adaptive_widgets/ui_utils.dart';

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
    "image": null,
    "loc_data": null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
              LocationForm(_setLocation, product),
              SizedBox(height: 10.0),
              ImageInput(_setImage, product),
              SizedBox(height: 10.0),
              _buildSubmitButton()
            ]),
      ),
    );
  }

  Widget _buildPageWithAppBar(Product product) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product"), elevation: getSpecificElevation(context),),
      body: _buildContentBody(product),
    );
  }

  Widget _builTitleTextField(Product product) {
    if (product != null && _titleController.text.isEmpty) {
      _titleController.text = product.title;
    } else if (product == null && _titleController.text.isEmpty) {
      _titleController.text = "";
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
      controller: _titleController,
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
    if (product != null && _descriptionController.text.isEmpty) {
      _descriptionController.text = product.description;
    } else if (product == null && _descriptionController.text.isEmpty) {
      _descriptionController.text = "";
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Description"),
      controller: _descriptionController,
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
    if (product != null && _priceController.text.isEmpty) {
      _priceController.text = product.price.toString();
    } else if (product == null && _priceController.text.isEmpty) {
      _priceController.text = "";
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price, \$"),
      controller: _priceController,
      validator: (String value) {
        if (double.tryParse(value.replaceFirst(RegExp(r','), '.')) == null) {
          return "Price is required and should be a number";
        }
      },
      onSaved: (String value) {
        _priceController.text = value.replaceFirst(RegExp(r','), '.');
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: AdaptiveProdgressIndicator())
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

  void _setImage(File imageFile) {
    _formData["image"] = imageFile;
  }

  void _submitForm(Function addProduct, Function updateProduct,
      Function selectProduct, int selectedProductIndex) {
    if (!_formKey.currentState.validate() ||
        (_formData["image"] == null && selectedProductIndex == -1)) {
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
    saveProduct(
            _titleController.text,
            _descriptionController.text,
            _formData["image"],
            double.parse(_priceController.text),
            _formData["loc_data"])
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
