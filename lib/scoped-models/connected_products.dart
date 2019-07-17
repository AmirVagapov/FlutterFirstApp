import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  User _authenticatedUser;
  final List<Product> _products = [];
  int _selProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
    final Product newProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    _products.add(newProduct);
    notifyListeners();
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorite = false;

  void selProductIndex(int index) {
    _selProductIndex = index;
    if (index == null) {
      notifyListeners();
    }
  }

  int get selectedProductIndex => _selProductIndex;

  bool get displayFavoritesOnly => _showFavorite;

  List<Product> get displayedProducts {
    if (_showFavorite) {
      return _products.where((product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  List<Product> get allProducts => List.from(_products);

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  void toggleProductFavoriteStatus() {
    final isCurrentlyFavorite = selectedProduct.isFavorite;
    final newFavoriteStatus = !isCurrentlyFavorite;
    final updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    _selProductIndex = null;
    notifyListeners();
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
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
