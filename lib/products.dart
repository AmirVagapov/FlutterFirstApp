import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  const Products([this.products = const []]);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset("assets/food.jpg"),
          Text(products[index])
        ],
      ),
    );
  }

  Widget _builProductList() {
    Widget productCard;
    if (products.isNotEmpty) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    } else {
      productCard = Center(child: Text("No products found, please add some"));
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return _builProductList();
  }
}
