import 'package:flutter_course/network/network_service.dart' as networkService;
import 'package:scoped_model/scoped_model.dart';
import "package:http/http.dart" as http;
import "dart:convert";

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
      notifyListeners();
    }
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _startLoading();
    final Product product = Product(
        id: Product.DEFAULT_ID,
        title: title,
        description: description,
        image:
            "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    try {
      final http.Response response = await networkService.addProduct(product);

      final Map<String, dynamic> responseBody = json.decode(response.body);
      final Product newProduct = Product(
          id: responseBody["name"],
          title: title,
          description: description,
          image: image,
          price: price,
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

  void toggleProductFavoriteStatus() {
    final isCurrentlyFavorite = selectedProduct.isFavorite;
    final newFavoriteStatus = !isCurrentlyFavorite;
    final updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    _selProductId = null;
    notifyListeners();
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
    _startLoading();
    final Product product = Product(
        id: selectedProductId,
        title: title,
        description: description,
        image:
            "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);

    try {
      await networkService.updateProduct(product, selectedProductId);

      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
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
      await networkService.deleteProduct(deletedProductId);
      _stopLoading();
      return true;
    } catch (error) {
      _stopLoading();
      return false;
    }
  }

  Future<Null> fetchProducts() async {
    _startLoading();

    try {
      _products = await networkService.fetchProducts();
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
  void login(String email, String password) {
    _authenticatedUser = User(id: "vsmdkvk", email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
