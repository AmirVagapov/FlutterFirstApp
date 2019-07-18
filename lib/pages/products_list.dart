import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildListItem(context, index, model),
        itemCount: model.allProducts.length,
      );
    });
  }

  Widget _buildListItem(BuildContext context, int index, MainModel model) {
    return Dismissible(
      key: Key(index.toString()),
      background: Container(color: Colors.red),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          model.selProductIndex(index);
          model.deleteProduct();
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
              model.selProductIndex(index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return ProductEditPage();
                }),
              ).then((_) => model.selProductIndex(null));
            },
          ),
        ),
        Divider()
      ]),
    );
  }
}
