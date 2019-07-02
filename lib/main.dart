import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_course/pages/auth.dart';
import 'package:flutter_course/pages/product.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/pages/products_admin.dart';

import 'package:flutter_course/product_manager.dart';

main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> _products = [];

  void _addProduct(Map<String, String> product) {
    setState(() => _products.add(product));
  }

  void _deleteProduct(int index) {
    setState(() => _products.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          // buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlue),
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.purple,
          brightness: Brightness.light),
      // home: AuthPage(),
      routes: {
        "/": (BuildContext context) =>
            ProductsPage(_products, _addProduct, _deleteProduct),
        "/admin": (BuildContext context) => ProductsAdminPage()
      },
      onGenerateRoute: (RouteSettings settings) {
        ///        "/product/1"

        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(
                  _products[index]["title"], _products[index]["image"]));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductsPage(_products, _addProduct, _deleteProduct));
      },
    );
  }
}
