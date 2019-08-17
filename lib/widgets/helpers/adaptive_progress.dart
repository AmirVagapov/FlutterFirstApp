import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/ui_utils.dart';

class AdaptiveProdgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSpecificWidget(
        CircularProgressIndicator(), CupertinoActivityIndicator(), context);
  }
}