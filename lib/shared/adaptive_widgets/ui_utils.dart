import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


Widget getSpecificWidget(
    Widget androidWidget, Widget iosWidget, BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return iosWidget;
  } else {
    return androidWidget;
  }
}

double getSpecificElevation(BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return 0.0;
  } else {
    return 4.0;
  }
}



