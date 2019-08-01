import 'package:flutter/material.dart';
import '../models/location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String imagePath;
  final String userEmail;
  final String userId;
  final LocationData location;
  final bool isFavorite;

  static const String DEFAULT_ID = "";

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.imagePath,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      this.isFavorite = false});

  Product.fromJson(Map<String, dynamic> json, String productId, bool isFavorite)
      : id = productId,
        title = json["title"],
        description = json["description"],
        price = json["price"],
        image = json["imageUrl"],
        imagePath = json["imagePath"],
        userEmail = json["userEmail"],
        userId = json["userId"],
        location = LocationData(
            address: json["address"],
            latitude: json["loc_lat"],
            longitude: json["loc_lng"]),
        isFavorite = isFavorite;

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "imageUrl": image,
        "imagePath": imagePath,
        "price": price.toDouble(),
        "userEmail": userEmail,
        "userId": userId,
        "address": location.address,
        "loc_lat": location.latitude,
        "loc_lng": location.longitude
      };
}
