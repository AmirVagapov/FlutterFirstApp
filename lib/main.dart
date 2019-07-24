import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/pages/auth.dart';
import 'package:flutter_course/pages/product.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/pages/products_admin.dart';
import 'package:flutter_course/scoped-models/main.dart';

import 'package:scoped_model/scoped_model.dart';

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
  final _model = MainModel();

  @override
  void initState() {
    _model.autoAthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            // buttonTheme: ButtonThemeData(buttonColor: Colors.lightBlue),
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.purple,
            brightness: Brightness.light,
            buttonColor: Colors.purple),
        // home: AuthPage(),
        routes: {
          "/": (BuildContext context) => ScopedModelDescendant<MainModel>(
                  builder:
                      (BuildContext context, Widget child, MainModel model) {
                return model.user == null ? AuthPage() : ProductsPage(model);
              }),
          "/products": (BuildContext context) => ProductsPage(_model),
          "/admin": (BuildContext context) => ProductsAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          ///        "/product/1"

          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product = _model.allProducts
                .firstWhere((product) => product.id == productId);
            _model.selectProduct(productId);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_model),
          );
        },
      ),
    );
  }
}
