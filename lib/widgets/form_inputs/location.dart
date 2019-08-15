import 'package:flutter/material.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/models/product.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/map_view_type.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/static_map_provider.dart';
import '../helpers/ensure_visible.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:location/location.dart' as geolocation;
import 'package:flutter_course/network/sensitive_info/keys.dart';


class LocationForm extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationForm(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationFormState();
  }
}

class _LocationFormState extends State<LocationForm> {
  Uri _staticMapUri;
  LocationData _locationData;
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _addressInputFocusNode = FocusNode();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _getStaticMapUri(widget.product.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMapUri(String address,
      {bool geocode = false, double lat, double lng}) async {
    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }

    if (geocode) {
      final Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/geocode/json",
        {"address": address, "key": apiKey},
      );

      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      final formattedAddress =
          decodedResponse['results'][0]["formatted_address"];
      final coords = decodedResponse["results"][0]['geometry']["location"];

      _locationData = LocationData(
          address: formattedAddress,
          latitude: coords["lat"],
          longitude: coords['lng']);
    } else if (widget.product != null && (lat == null || lng == null)) {
      _locationData = widget.product.location;
    } else {
      _locationData =
          LocationData(latitude: lat, longitude: lng, address: address);
    }

    if (mounted) {
      final StaticMapProvider staticMapProvider =
          StaticMapProvider(apiKey);
      final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
        Marker("Position", "Position", _locationData.latitude,
            _locationData.longitude)
      ],
          width: 500,
          height: 300,
          maptype: StaticMapViewType.roadmap,
          center: Location(_locationData.latitude, _locationData.longitude));

      setState(() {
        widget.setLocation(_locationData);
        _addressController.text = _locationData.address;
        _staticMapUri = staticMapUri;
      });
    }
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMapUri(_addressController.text,geocode: true);
    }
  }

  void _getCurrentLocation() async {
    try {
      final geolocation.Location location = geolocation.Location();
      final currentCoords = await location.getLocation();
      final currentAddress = await getCurrentAddress(
          currentCoords.latitude, currentCoords.longitude);

      _getStaticMapUri(currentAddress,
          geocode: false,
          lat: currentCoords.latitude,
          lng: currentCoords.longitude);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<String> getCurrentAddress(double lat, double lng) async {
    final Uri uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/geocode/json",
      {"latlng": "$lat,$lng", "key": apiKey},
    );

    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]["formatted_address"];
    return formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressController,
            validator: (String value) {
              if (_locationData == null || value.isEmpty) {
                return "There is no valid location";
              }
            },
            decoration: InputDecoration(labelText: "Address"),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.location_on),
              SizedBox(
                width: 5.0,
              ),
              Text("Use current location")
            ],
          ),
          onPressed: _getCurrentLocation,
        ),
        SizedBox(
          height: 10.0,
        ),
        _staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString())
      ],
    );
  }
}
