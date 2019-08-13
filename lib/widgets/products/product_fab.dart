import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: ScaleTransition(
              scale: _getAnimationScale(1.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Theme.of(context).cardColor,
                heroTag: "mail",
                onPressed: () => _sendEmail(model.selectedProduct),
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: ScaleTransition(
              scale: _getAnimationScale(0.5),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Theme.of(context).cardColor,
                heroTag: "favorite",
                onPressed: () {
                  model.toggleProductFavoriteStatus();
                },
                child: Icon(
                  model.selectedProduct.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Container(
            child: FloatingActionButton(
              heroTag: "options",
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      alignment: FractionalOffset.center,
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * pi),
                      child: Icon(_controller.isDismissed
                          ? Icons.more_vert
                          : Icons.close),
                    );
                  }),
            ),
          )
        ],
      );
    });
  }

  Animation<double> _getAnimationScale(double endPoint) {
    return CurvedAnimation(
        curve: Interval(0.0, endPoint, curve: Curves.elasticOut),
        parent: _controller);
  }

  void _sendEmail(Product product) async {
    final url =
        "mailto:${product.userEmail}?subject=ProductFeedback&body=${product.title} is awesome";
    // final url = "tel:89876039167";
    // final url = "https://www.yandex.ru";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Can't launch ${product.userEmail}";
    }
  }
}
