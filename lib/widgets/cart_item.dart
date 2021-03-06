import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart' show Cart;

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quandity;
  final double price;

  CartItem(this.id, this.productId, this.title, this.quandity, this.price);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No'),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).errorColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes'),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${quandity * price}'),
            trailing: Text('$quandity x'),
          ),
        ),
      ),
    );
  }
}
