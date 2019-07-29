import 'dart:async';

import 'package:flutter_course/models/auth_mode.dart';
import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/network/product_network_service.dart'
    as productNetworkService;
import 'package:flutter_course/network/user_network_service.dart'
    as userNetworkService;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:rxdart/subjects.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  User _authenticatedUser;
  List<Product> _products = [];
  String _selProductId;
  bool _isLoading = false;

  String get selectedProductId => _selProductId;

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }
}

mixin ProductsModel on ConnectedProductsModel {
  List<Product> get allProducts => List.from(_products);

  bool _showFavorite = false;

  bool get displayFavoritesOnly => _showFavorite;

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((product) => product.id == _selProductId);
  }

  List<Product> get displayedProducts {
    if (_showFavorite) {
      return _products.where((product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((product) => product.id == _selProductId);
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId == null) {
      return;
    }
    notifyListeners();
  }

  Future<bool> addProduct(String title, String description, String image,
      double price, LocationData locData) async {
    _startLoading();
    final Product product = Product(
        id: Product.DEFAULT_ID,
        title: title,
        description: description,
        image: image,
        price: price,
        location: locData,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    try {
      final http.Response response = await productNetworkService.addProduct(
          product, _authenticatedUser.token, locData);

      final Map<String, dynamic> responseBody = json.decode(response.body);
      final Product newProduct = Product(
          id: responseBody["name"],
          title: title,
          description: description,
          image: image,
          price: price,
          location: locData,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);

      _products.add(newProduct);
      _stopLoading();
      return true;
    } catch (error) {
      _stopLoading();
      return false;
    }
  }

  void toggleProductFavoriteStatus() async {
    final isCurrentlyFavorite = selectedProduct.isFavorite;
    final newFavoriteStatus = !isCurrentlyFavorite;
    final updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: _authenticatedUser.email,
        location: selectedProduct.location,
        userId: _authenticatedUser.id,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    final selectedProductId = selectedProduct.id;
    notifyListeners();
    _selProductId = null;
    http.Response response;
    if (newFavoriteStatus) {
      response = await productNetworkService.addToWishlist(
          selectedProductId, _authenticatedUser.id, _authenticatedUser.token);
    } else {
      response = await productNetworkService.removeFromToWishlist(
          selectedProductId, _authenticatedUser.id, _authenticatedUser.token);
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final updatedProduct = Product(
          id: selectedProductId,
          title: selectedProduct.title,
          description: selectedProduct.description,
          image: selectedProduct.image,
          price: selectedProduct.price,
          userEmail: _authenticatedUser.email,
          location: selectedProduct.location,
          userId: _authenticatedUser.id,
          isFavorite: !newFavoriteStatus);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      _selProductId = null;
    }
  }

  Future<bool> updateProduct(String title, String description, String image,
      double price, LocationData locData) async {
    _startLoading();
    final Product product = Product(
        id: selectedProductId,
        title: title,
        description: description,
        image: "https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG",
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        location: locData,
        isFavorite: selectedProduct.isFavorite);

    try {
      await productNetworkService.updateProduct(
          product, selectedProductId, _authenticatedUser.token);

      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: "https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG",
          price: price,
          userEmail: selectedProduct.userEmail,
          location: locData,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      _stopLoading();
      return true;
    } catch (error) {
      _stopLoading();
      return false;
    }
  }

  Future<bool> deleteProduct() async {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();

    try {
      await productNetworkService.deleteProduct(
          deletedProductId, _authenticatedUser.token);
      _stopLoading();
      return true;
    } catch (error) {
      _stopLoading();
      return false;
    }
  }

  Future<Null> fetchProducts({onlyForUser = false}) async {
    _startLoading();

    try {
      final loadedProducts = await productNetworkService.fetchProducts(
          _authenticatedUser.token, _authenticatedUser.id);
      _products = onlyForUser
          ? loadedProducts
              .where(
                  (Product product) => product.userId == _authenticatedUser.id)
              .toList()
          : loadedProducts;
      _stopLoading();
      _selProductId = null;
    } catch (error) {
      _stopLoading();
    }
  }

  void toggleFavoriteMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  final PublishSubject<bool> _userSubject = PublishSubject<bool>();

  PublishSubject get userSubject => _userSubject;
  User get user => _authenticatedUser;

  Future<Map<String, dynamic>> authenticate(
      String email, String password, AuthMode authMode) async {
    _startLoading();
    final Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    http.Response response;
    if (authMode == AuthMode.Login) {
      response = await userNetworkService.login(authData);
    } else {
      response = await userNetworkService.signup(authData);
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = "Something went wrong";
    if (responseData.containsKey("idToken")) {
      hasError = false;
      message = "Authentication succeeded";
      _authenticatedUser = User(
          email: email,
          id: responseData["localId"],
          token: responseData['idToken']);
      _userSubject.add(true);
      _setAuthTimeout(int.parse(responseData["expiresIn"]));
      final prefs = await SharedPreferences.getInstance();
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData["expiresIn"])));
      prefs.setString("token", responseData["idToken"]);
      prefs.setString("userEmail", email);
      prefs.setString("userId", responseData["localId"]);
      prefs.setString("expiryTime", expiryTime.toIso8601String());
    } else if (responseData["error"]["message"] == "EMAIL_EXISTS") {
      message = "This email already exist!";
    } else if (responseData["error"]["message"] == "EMAIL_NOT_FOUND") {
      message = "This email was not found!";
    } else if (responseData["error"]["message"] == "INVALID_PASSWORD") {
      message = "Password is invalid";
    }
    _stopLoading();
    return {"success": !hasError, "message": message};
  }

  void autoAthenticate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final expiryTime = prefs.getString("expiryTime");
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTime);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final userEmail = prefs.getString("userEmail");
      final userId = prefs.getString("userId");
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _setAuthTimeout(tokenLifespan);
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove("userEmail");
    prefs.remove("userId");
    _userSubject.add(false);
  }

  void _setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
