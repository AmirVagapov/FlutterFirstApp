import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/helpers/ui_utils.dart';
import 'package:flutter_course/widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../widgets/helpers/adaptive_progress.dart';
import 'package:flutter/cupertino.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductsPage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          elevation: getSpecificElevation(context),
          title: Text("EasyList"),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleFavoriteMode();
                },
              );
            })
          ],
        ),
        body: _buildProductList());
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: getSpecificElevation(context),
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/admin");
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
          child: Text("Product list is empty"),
        );
        if (model.displayedProducts.isNotEmpty && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(
            child: AdaptiveProdgressIndicator(),
          );
        }
        return RefreshIndicator(child: content, onRefresh: model.fetchProducts);
      },
    );
  }
}
