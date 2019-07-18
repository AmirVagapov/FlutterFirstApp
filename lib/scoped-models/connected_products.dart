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

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> productData = {
      "title": title,
      "description": description,
      "image":
          "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "price": price,
      "userEmail": _authenticatedUser.email,
      "userId": _authenticatedUser.id
    };

    return http
        .post("https://flutter-products-f7955.firebaseio.com/products.json",
            body: json.encode(productData))
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

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http
        .get("https://flutter-products-f7955.firebaseio.com/products.json")
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productsData = jsonDecode(response.body);

      if (productsData == null) {
        _isLoading = false;
        notifyListeners();
      }

      productsData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            image: productData["image"],
            price: productData["price"],
            userEmail: productData["userEmail"],
            userId: productData["userId"]);

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
