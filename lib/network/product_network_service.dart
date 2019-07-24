import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

String _defaultUrl(String tokenId) {
  return "https://flutter-products-f7955.firebaseio.com/products.json?auth=$tokenId";
}

String _getUrlWithProductId(String productId, String tokenId) =>
    "https://flutter-products-f7955.firebaseio.com/products/${productId}.json?auth=$tokenId";

Future<http.Response> addProduct(Product product, String tokenId) {
  return http.post(_defaultUrl(tokenId), body: jsonEncode(product));
}

Future<http.Response> updateProduct(
    Product product, String productId, String tokenId) {
  return http.put(_getUrlWithProductId(productId, tokenId),
      body: jsonEncode(product));
}

Future<http.Response> deleteProduct(String productId, String tokenId) {
  return http.delete(_getUrlWithProductId(productId, tokenId));
}

Future<List<Product>> fetchProducts(String tokenId) async {
  final productStream = _streamProduct(tokenId);
  final List<Product> fetchedProductList = [];

  await for (var product in productStream) {
    fetchedProductList.add(product);
  }

  return fetchedProductList;
}

Stream<Product> _streamProduct(String tokenId) async* {
  http.Response response = await http.get(_defaultUrl(tokenId), headers: {"Content-Type": "application/json"});
  print(response.body);

  final Map<String, dynamic> productsData = jsonDecode(response.body);

  if (productsData == null || productsData.isEmpty) {
    yield null;
  }

  for (int i = 0; i < productsData.length; i++) {
    yield Product.fromJson(
        productsData.values.elementAt(i), productsData.keys.elementAt(i));
  }
}
