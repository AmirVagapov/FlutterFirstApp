import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
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
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            NetworkImageWithPlaceholder(product.image),
            SizedBox(height: 10.0),
            TitleDefault(product.title),
            SizedBox(height: 10.0),
            _buildAddressPriceRow(product.location.address, product.price),
            Container(
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.0),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildAddressPriceRow(String address, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showMap,
          child: Text(
            address,
            style: TextStyle(fontFamily: "Oswald", color: Colors.grey),
          ),
        ),
        Container(
          child: Text("|"),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        Text(
          "\$$price",
          style: TextStyle(fontFamily: "Oswald", color: Colors.grey),
        )
      ],
    );
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
