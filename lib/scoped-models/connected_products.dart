import 'package:scoped_model/scoped_model.dart';
import "package:http/http.dart" as http;
import "dart:convert";

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  User _authenticatedUser;
  List<Product> _products = [];
  int _selProductIndex;
  bool _isLoading = false;

  int get selectedProductIndex => _selProductIndex;

  List<Product> get allProducts => List.from(_products);

  void selProductIndex(int index) {
    _selProductIndex = index;
    if (index == null) {
      notifyListeners();
    }
  }

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Product product = Product(
        id: "",
        title: title,
        description: description,
        image:
            "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    return http
        .post("https://flutter-products-f7955.firebaseio.com/products.json",
            body: jsonEncode(product))
        .then((http.Response response) {
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
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorite = false;

  bool get displayFavoritesOnly => _showFavorite;

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  List<Product> get displayedProducts {
    if (_showFavorite) {
      return _products.where((product) => product.isFavorite).toList();
    }
    return List.from(_products);
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

  Future<Null> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Product product = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image:
            "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);

    return http
        .put(
            "https://flutter-products-f7955.firebaseio.com/products/${selectedProduct.id}.json",
            body: jsonEncode(product))
        .then((http.Response response) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductIndex = null;
    notifyListeners();
    http
        .delete(
            "https://flutter-products-f7955.firebaseio.com/products/${deletedProductId}.json")
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();

    return http
        .get("https://flutter-products-f7955.firebaseio.com/products.json")
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productsData = jsonDecode(response.body);

      if (productsData == null) {
        _isLoading = false;
        notifyListeners();
      }

      productsData.forEach((String productId, dynamic productData) {
        final Product product = Product.fromJson(productData, productId);
        fetchedProductList.add(product);
      });

      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
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
