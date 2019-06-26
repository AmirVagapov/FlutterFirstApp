import 'package:flutter/material.dart';
import 'package:flutter_course/product_control.dart';
import 'package:flutter_course/products.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

  const ProductManager({this.startingProduct});

  @override
  State<StatefulWidget> createState() {
    return ProductManagerState();
  }
}

class ProductManagerState extends State<ProductManager> {
  final List<String> _products = [];

  @override
  void initState() {
    super.initState();
    if(widget.startingProduct != null) {
    _products.add(widget.startingProduct);
    }
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(String product) {
    setState(() => _products.add(product));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(10.0),
        child: ProductControl(_addProduct),
      ),
      Expanded(child: Products(_products))
    ]);
  }
}
