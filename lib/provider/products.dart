import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final _baseUrl =
      Uri.parse('https://flutter-shop-f3ea1-default-rtdb.firebaseio.com');

  List<Product> _items = [
    // Product(
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String _authToken;
  final String _userId;

  Products(this._authToken, this._userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filterQuery =
          filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
      final res = await http.get(
          Uri.parse('$_baseUrl/products.json?auth=$_authToken&$filterQuery'));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final favRes = await http.get(
          Uri.parse('$_baseUrl/userFavorites/$_userId.json?auth=$_authToken'));
      final favoriteData = json.decode(favRes.body);

      List<Product> loadedProducts = [];
      extractedData.forEach((id, prod) {
        loadedProducts.add(
          Product(
            id: id,
            title: prod['title'],
            description: prod['description'],
            price: prod['price'],
            imageUrl: prod['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[id] ?? false,
          ),
        );
      });
      _items = loadedProducts;
    } catch (err) {
      throw err;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> addProduct(Product item) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/products.json?auth=$_authToken'),
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'creatorId': _userId,
        }),
      );
      _items.add(Product(
        title: item.title,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        id: json.decode(res.body)['name'],
      ));
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product item) async {
    var prodIndex = _items.indexWhere((item) => item.id == id);
    if (prodIndex >= 0) {
      http.patch(Uri.parse('$_baseUrl/products/$id.json?auth=$_authToken'),
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imageUrl': item.imageUrl,
          }));
      _items[prodIndex] = item;
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    // var prodIndex = _items.indexWhere((item) => item.id == id);
    // Product? item = _items[prodIndex];
    // _items.removeAt(prodIndex);
    // notifyListeners();
    // final res = await http.delete(Uri.parse('$_baseUrl/$id.jso'));
    // if (res.statusCode >= 400) {
    //   _items.insert(prodIndex, item);
    //   notifyListeners();
    //   throw HttpException('Could not able to delete.');
    // }
    // item = null;
    final res = await http
        .delete(Uri.parse('$_baseUrl/products/$id.json?auth=$_authToken'));
    if (res.statusCode >= 400) {
      throw HttpException('Could not able to delete.');
    } else {
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }
}
