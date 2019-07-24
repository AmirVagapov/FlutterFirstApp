import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String userEmail;
  final String userId;
  final bool isFavorite;

  static const String DEFAULT_ID = "";

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      this.isFavorite = false});

  Product.fromJson(Map<String, dynamic> json, String productId)
      : id = productId,
        title = json["title"],
        description = json["description"],
        price = double.parse(json["price"]),
        image = json["image"],
        userEmail = json["userEmail"],
        userId = json["userId"],
        isFavorite = false;

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "price": price.toString(),
        "userEmail": userEmail,
        "userId": userId
      };
}
