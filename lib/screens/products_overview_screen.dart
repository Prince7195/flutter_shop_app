import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFilters = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, ch) {
              return Badge(
                child: ch as Widget,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFilters = true;
                } else {
                  _showOnlyFilters = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Favorites"),
                    )
                  ],
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.add_business,
                      color: Colors.brown,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Show All"),
                    )
                  ],
                ),
                value: FilterOptions.All,
              )
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFilters),
    );
  }
}
