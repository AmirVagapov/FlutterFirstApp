import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_create.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/pages/products_list.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                AppBar(
                  title: Text("Choose"),
                ),
                ListTile(
                  title: Text("Products List"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/");
                  },
                )
              ],
            ),
          ),
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
            children: <Widget>[ProductCreatePage(), ProductsListPage()],
          ),
        ));
  }
}
