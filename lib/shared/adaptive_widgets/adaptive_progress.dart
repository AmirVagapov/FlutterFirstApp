import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../adaptive_widgets/ui_utils.dart';

class AdaptiveProdgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getSpecificWidget(
        CircularProgressIndicator(), CupertinoActivityIndicator(), context);
  }
}