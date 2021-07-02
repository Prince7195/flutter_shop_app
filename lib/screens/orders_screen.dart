import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/orders.dart' show Orders;
import 'package:shop_app/widgets/AppDrawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetorders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // Do error stuff
              return Center(
                child: Text("Oops.. Failed to fetch the Orders!"),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, ordersData, child) {
                return ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (cts, idx) {
                    return OrderItem(ordersData.orders[idx]);
                  },
                );
              });
            }
          }
        },
      ),
    );
  }
}
