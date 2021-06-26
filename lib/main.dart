import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';

import './provider/cart.dart';
import './provider/products.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './color_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Products()),
      ChangeNotifierProvider(create: (_) => Cart()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        accentColor: accentColor,
        fontFamily: "Lato",
      ),
      // home: ProductsOverviewScreen(),
      routes: {
        '/': (_) => ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
        CartScreen.routeName: (_) => CartScreen(),
      },
    );
  }
}
