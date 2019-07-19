import 'package:flutter/widgets.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;

  NetworkImageWithPlaceholder(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage(imageUrl),
      placeholder: AssetImage("assets/food.jpg"),
      fit: BoxFit.cover,
      height: 300.0,
    );
  }
}
