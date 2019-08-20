import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdaptiveButtonWidget extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Color textColor;

  AdaptiveButtonWidget(
      {this.child, this.onPressed, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return _getAdaptiveButton(child, onPressed, textColor, context);
  }
  Widget _getAdaptiveButton(
    Widget child, Function onPressed, Color textColor, BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.android) {
    return RaisedButton(
      child: child,
      onPressed: onPressed,
      textColor: textColor,
    );
  } else {
    return CupertinoButton(child: child, onPressed: onPressed, color: Theme.of(context).buttonColor,);
  }
}
}


