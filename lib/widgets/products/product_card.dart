import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import './price_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceContainer() {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TitleDefault(product.title),
          SizedBox(width: 8.0),
          PriceTag(product.price.toString())
        ]));
  }

  Widget _buildButtonActions(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => Navigator.pushNamed<bool>(
                    context, "/product/$productIndex")),
            IconButton(
              icon: Icon(
                model.products[productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () {
                model.selectedProductIndex = productIndex;
                model.toggleProductFavoriteStatus();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product.image),
          _buildTitlePriceContainer(),
          AddressTag("Union Square, San Francisco"),
          _buildButtonActions(context)
        ],
      ),
    );

  }
}
