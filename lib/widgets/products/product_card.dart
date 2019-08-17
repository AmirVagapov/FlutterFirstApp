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

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: NetworkImageWithPlaceholder(product.image),
          ),
          _buildTitlePriceContainer(),
          AddressTag(product.location.address),
          _buildButtonActions(context)
        ],
      ),
    );
  }

  Widget _buildTitlePriceContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(child: TitleDefault(product.title)),
        SizedBox(width: 8.0),
         PriceTag(product.price.toString()),
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
                onPressed: () {
                  model.selectProduct(product.id);
                  Navigator.pushNamed<bool>(context,
                          "/product/${product.id}")
                      .then((_) {
                    model.selectProduct(null);
                  });
                }),
            IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () {
                model.selectProduct(product.id);
                model.toggleProductFavoriteStatus();
                model.selectProduct(null);
              },
            )
          ],
        );
      },
    );
  }
}
