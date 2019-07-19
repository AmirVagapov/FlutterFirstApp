import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/pages/products_list.dart';
import 'package:flutter_course/scoped-models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: Text("Manage Products"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Create Product", icon: Icon(Icons.create)),
                Tab(text: "My Products", icon: Icon(Icons.list))
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[ProductEditPage(), ProductsListPage(model)],
          ),
        ));
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Products List"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/products");
            },
          )
        ],
      ),
    );
  }
}
