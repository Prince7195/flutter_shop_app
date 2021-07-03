import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

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

  final String _authToken;
  final String _userId;

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String _baseUrl =
      'https://flutter-shop-f3ea1-default-rtdb.firebaseio.com/orders';

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse('$_baseUrl/$_userId.json?auth=$_authToken');
    final res = await http.post(url,
        body: json.encode({
          'totalAmount': total,
          'createdDate': timeStamp.toIso8601String(),
          'products': cartProducts.map((cp) {
            return {
              'id': cp.id,
              'title': cp.title,
              'price': cp.price,
              'quandity': cp.quandity,
            };
          }).toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          totalAmount: total,
          products: cartProducts,
          createdDate: timeStamp,
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetorders() async {
    final url = Uri.parse('$_baseUrl/$_userId.json?auth=$_authToken');
    final res = await http.get(url);
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extractedData.forEach((id, order) {
      loadedOrders.add(OrderItem(
        id: id,
        totalAmount: order['totalAmount'],
        createdDate: DateTime.parse(order['createdDate']),
        products: (order['products'] as List<dynamic>).map((prod) {
          return CartItem(
            id: prod['id'],
            title: prod['title'],
            quandity: prod['quandity'],
            price: prod['price'],
          );
        }).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
