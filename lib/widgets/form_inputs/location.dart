import 'package:flutter/material.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/map_view_type.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/static_map_provider.dart';
import '../helpers/ensure_visible.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationForm extends StatefulWidget {

  final Function setLocation;

  LocationForm(this.setLocation);

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
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMapUri(String address) async {
    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }
    final Uri uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/geocode/json",
      {"address": address, "key": "AIzaSyA2AbM1JMi0bkeoSIEECAF91tV-PxMeujo"},
    );

    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]["formatted_address"];
    final coords = decodedResponse["results"][0]['geometry']["location"];

    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords["lat"],
        longitude: coords['lng']);

    final StaticMapProvider staticMapProvider =
        StaticMapProvider("AIzaSyA2AbM1JMi0bkeoSIEECAF91tV-PxMeujo");
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

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMapUri(_addressController.text);
    }
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
        Image.network(_staticMapUri.toString())
      ],
    );
  }
}
