import 'package:flutter/material.dart';
import 'package:flutter_course/product_control.dart';
import 'package:flutter_course/products.dart';

class ProductManager extends StatefulWidget {
  final Map<String, String> startingProduct;

  const ProductManager({this.startingProduct});

  @override
  State<StatefulWidget> createState() {
    return ProductManagerState();
  }
}

class ProductManagerState extends State<ProductManager> {
  final List<Map<String, String>> _products = [];

  @override
  void initState() {
    super.initState();
    if (widget.startingProduct != null) {
      _products.add(widget.startingProduct);
    }
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(Map<String, String> product) {
    setState(() => _products.add(product));
  }

  void _deleteProduct(int index) {
    setState(() => _products.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(10.0),
        child: ProductControl(_addProduct),
      ),
      Expanded(child: Products(_products, deleteProduct: _deleteProduct))
    ]);
  }
}
