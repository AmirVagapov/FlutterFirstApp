import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("SAVE"),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Center(child: Text("This is modal screen"));
              });
        },
      ),
    );
  }
}
