import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.totalAmount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd MMM yyyy hh:mm').format(widget.order.createdDate),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 20, 140),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (_, idx) {
                    var prod = widget.order.products[idx];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${prod.quandity}x  \$${prod.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
