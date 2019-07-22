import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

String get _defaultUrl =>
    "https://flutter-products-f7955.firebaseio.com/products.json";
String getUrlWithId(String productId) =>
    "https://flutter-products-f7955.firebaseio.com/products/${productId}.json";

Future<http.Response> addProduct(Product product) {
  return http.post(_defaultUrl, body: jsonEncode(product));
}

Future<http.Response> updateProduct(Product product, String productId) {
  return http.put(getUrlWithId(productId), body: jsonEncode(product));
}

Future<http.Response> deleteProduct(String productId) {
  return http.delete(getUrlWithId(productId));
}

Future<List<Product>> fetchProducts() async {
  final productStream = _streamProduct();
  final List<Product> fetchedProductList = [];

  await for (var product in productStream) {
    fetchedProductList.add(product);
  }

  return fetchedProductList;
}

Stream<Product> _streamProduct() async* {
  http.Response response = await http.get(_defaultUrl);

  final Map<String, dynamic> productsData = jsonDecode(response.body);

  if (productsData == null || productsData.isEmpty) {
    yield null;
  }

  for (int i = 0; i < productsData.length; i++) {
    yield Product.fromJson(
        productsData.values.elementAt(i), productsData.keys.elementAt(i));
  }
}
