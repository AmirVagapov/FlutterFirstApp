import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]["image"]),
          Text(products[index]["title"]),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  child: Text("Details"),
                  onPressed: () =>
                      Navigator.pushNamed<bool>(context, "/product/$index"))
            ],
          )
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
