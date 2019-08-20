import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final String title;
  final Function onChanged;

  AdaptiveSwitch(this.value, this.title, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return _getAdaptiveSwitch(context);
  }

  Widget _getAdaptiveSwitch(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return ListTile(
        title: Text(title),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      );
    } else {
      return SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
      );
    }
  }
}
