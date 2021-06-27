import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quandity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quandity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quandity);
    });
    return total;
  }

  void addItems(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (exsitingCartItem) {
        return CartItem(
          id: exsitingCartItem.id,
          title: exsitingCartItem.title,
          quandity: exsitingCartItem.quandity + 1,
          price: exsitingCartItem.price,
        );
      });
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quandity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quandity > 1) {
      _items.update(
        productId,
        (exCIt) => CartItem(
          id: exCIt.id,
          title: exCIt.title,
          quandity: exCIt.quandity - 1,
          price: exCIt.price,
        ),
      );
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
