import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const Products(this.products);

  Widget _builProductList() {
    Widget productCard;
    if (products.isNotEmpty) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
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
