import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_elements/dialog_error.dart';
import '../shared/adaptive_widgets/adaptive_progress.dart';
import 'package:flutter/cupertino.dart';

class ProductsListPage extends StatefulWidget {
  final MainModel model;

  ProductsListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return ProductListPageState();
  }
}

class ProductListPageState extends State<ProductsListPage> {
  @override
  void initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).detach();
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RefreshIndicator(
          child: model.isLoading
              ? Center(child: AdaptiveProdgressIndicator())
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      _buildListItem(context, index, model),
                  itemCount: model.allProducts.length,
                ),
          onRefresh: () {
            return model.fetchProducts(onlyForUser: true);
          });
    });
  }

  Widget _buildListItem(BuildContext context, int index, MainModel model) {
    return Dismissible(
      key: Key(model.allProducts[index].id),
      background: Container(color: Colors.red),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          model.selectProduct(model.allProducts[index].id);
          model.deleteProduct().then((bool success) {
            if (success) return;
            ErrorDialog().show(context);
          });
        }
      },
      child: Column(children: [
        ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(model.allProducts[index].image)),
          title: Text(model.allProducts[index].title),
          subtitle: Text("\$${model.allProducts[index].price}"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              model.selectProduct(model.allProducts[index].id);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return ProductEditPage();
                }),
              ).then((_) => model.selectProduct(null));
            },
          ),
        ),
        Divider()
      ]),
    );
  }
}
