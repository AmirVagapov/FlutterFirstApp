import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/products/product_fab.dart';
import 'package:flutter_course/widgets/ui_elements/network_image_with_placeholder.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:map_view/map_view.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 256.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(product.title),
                alignment: Alignment.bottomCenter,
              ),
              centerTitle: true,
              background: Hero(
                tag: product.id,
                child: NetworkImageWithPlaceholder(product.image),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _buildTitleAndPrice(),
              SizedBox(height: 10.0),
              _buildAddress(product.location.address),
              Container(
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10.0),
              ),
            ]),
          ),
        ]),
        floatingActionButton: ProductFab(product),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 4,
          ),
          Expanded(
            child: TitleDefault(product.title),
            flex: 6,
          ),
          Expanded(
            child: Text(
              "\$${product.price}",
              style: TextStyle(fontFamily: "Oswald", color: Colors.grey),
            ),
            flex: 2,
          )
        ],
      ),
    );
  }

  Widget _buildAddress(String address) {
    return GestureDetector(
        onTap: _showMap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            address,
            style: TextStyle(
              fontFamily: "Oswald",
              color: Colors.grey,
            ),
          ),
        ));
  }

  void _showMap() {
    final mapView = MapView();
    final List<Marker> marker = [
      Marker("position", "Position", product.location.latitude,
          product.location.longitude)
    ];
    mapView.show(
        MapOptions(
          mapViewType: MapViewType.normal,
          initialCameraPosition: CameraPosition(
            Location(product.location.latitude, product.location.longitude),
            15.0,
          ),
        ),
        toolbarActions: [ToolbarAction("Close", 1)]);

    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });

    mapView.onMapReady.listen((_) {
      mapView.setMarkers(marker);
    });
  }
}
