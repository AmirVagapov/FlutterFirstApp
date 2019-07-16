import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildListItem(context, index, model),
        itemCount: model.products.length,
      );
    });
  }

  Widget _buildListItem(BuildContext context, int index, ProductsModel model) {
    return Dismissible(
      key: Key(index.toString()),
      background: Container(color: Colors.red),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          model.selectedProductIndex = index;
          model.deleteProduct();
        }
      },
      child: Column(children: [
        ListTile(
          leading: CircleAvatar(
              backgroundImage: AssetImage(model.products[index].image)),
          title: Text(model.products[index].title),
          subtitle: Text("\$${model.products[index].price}"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              model.selectedProductIndex = index;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return ProductEditPage();
                }),
              );
            },
          ),
        ),
        Divider()
      ]),
    );
  }
}
