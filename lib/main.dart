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
import 'package:flutter_course/widgets/helpers/custom_route.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_course/network/sensitive_info/keys.dart';
import 'package:scoped_model/scoped_model.dart';

main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  MapView.setApiKey(apiKey);
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
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAthenticate();
    _model.userSubject.listen((isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
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
            buttonColor: Colors.purple,
            ),
        // home: AuthPage(),
        routes: {
          "/": (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          "/admin": (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model)
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

            return CustomRoute<bool>(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return CustomRoute(
            builder: (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          );
        },
      ),
    );
  }
}
