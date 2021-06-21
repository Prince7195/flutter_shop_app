import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/products.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './color_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          accentColor: accentColor,
          fontFamily: "Lato",
        ),
        // home: ProductsOverviewScreen(),
        routes: {
          '/': (_) => ProductsOverviewScreen(),
          '/product-detail': (_) => ProductDetailScreen(),
        },
      ),
    );
  }
}
