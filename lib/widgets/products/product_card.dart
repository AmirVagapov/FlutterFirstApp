import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import './price_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import '../ui_elements/network_image_with_placeholder.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          NetworkImageWithPlaceholder(product.image),
          _buildTitlePriceContainer(),
          AddressTag(product.location.address),
          Text(product.userEmail),
          _buildButtonActions(context)
        ],
      ),
    );
  }

  Widget _buildTitlePriceContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child:TitleDefault(product.title), flex: 4),
        SizedBox(width: 8.0),
        Expanded(child:PriceTag(product.price.toString()), flex: 1,)
      ]),
    );
  }

  Widget _buildButtonActions(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () => Navigator.pushNamed<bool>(
                  context, "/product/${model.allProducts[productIndex].id}"),
            ),
            IconButton(
              icon: Icon(
                model.allProducts[productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () {
                model.selectProduct(model.allProducts[productIndex].id);
                model.toggleProductFavoriteStatus();
              },
            )
          ],
        );
      },
    );
  }
}
