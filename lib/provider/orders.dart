import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime createdDate;

  OrderItem({
    required this.id,
    required this.totalAmount,
    required this.products,
    required this.createdDate,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          totalAmount: total,
          products: cartProducts,
          createdDate: DateTime.now(),
        ));
    notifyListeners();
  }
}
