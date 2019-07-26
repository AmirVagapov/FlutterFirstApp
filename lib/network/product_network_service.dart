import 'package:flutter_course/models/location_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

String _defaultUrl(String tokenId) {
  return "https://flutter-products-f7955.firebaseio.com/products.json?auth=$tokenId";
}

String _getUrlWithProductId(String productId, String tokenId) =>
    "https://flutter-products-f7955.firebaseio.com/products/${productId}.json?auth=$tokenId";

String _getUrlWithWishlist(String productId, String userId, String tokenId) =>
    "https://flutter-products-f7955.firebaseio.com/products/${productId}/wishlistUser/$userId.json?auth=$tokenId";

Future<http.Response> addProduct(
    Product product, String tokenId, LocationData locData) async {
  final Map<String, dynamic> data = {
    'title': product.title,
    'description': product.description,
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
    'price': product.price,
    'userEmail': product.userEmail,
    'userId': product.userId,
    'loc_lat': locData.latitude,
    "loc_lng": locData.longitude,
    "address": locData.address
  };
  return await http.post(_defaultUrl(tokenId), body: jsonEncode(data));
}

Future<http.Response> addToWishlist(
  String productId,
  String userId,
  String tokenId,
) async {
  return await http.put(_getUrlWithWishlist(productId, userId, tokenId),
      body: json.encode(true));
}

Future<http.Response> removeFromToWishlist(
  String productId,
  String userID,
  String tokenId,
) async {
  return await http.delete(_getUrlWithWishlist(productId, userID, tokenId));
}

Future<http.Response> updateProduct(
    Product product, String productId, String tokenId) async {
  return await http.put(_getUrlWithProductId(productId, tokenId),
      body: jsonEncode(product));
}

Future<http.Response> deleteProduct(String productId, String tokenId) async {
  return await http.delete(_getUrlWithProductId(productId, tokenId));
}

Future<List<Product>> fetchProducts(String tokenId, String userId) async {
  final productStream = _streamProduct(tokenId, userId);
  final List<Product> fetchedProductList = [];

  await for (var product in productStream) {
    fetchedProductList.add(product);
  }

  return fetchedProductList;
}

Stream<Product> _streamProduct(String tokenId, String userId) async* {
  http.Response response = await http.get(_defaultUrl(tokenId));
  print(response.body);

  final Map<String, dynamic> productsData = jsonDecode(response.body);

  if (productsData == null || productsData.isEmpty) {
    yield null;
  }

  for (int i = 0; i < productsData.length; i++) {
    final bool isFavorite =
        productsData.values.elementAt(i)["wishlistUser"] == null
            ? false
            : (productsData.values.elementAt(i)["wishlistUser"]
                    as Map<String, dynamic>)
                .containsKey(userId);
    yield Product.fromJson(productsData.values.elementAt(i),
        productsData.keys.elementAt(i), isFavorite);
  }
}
