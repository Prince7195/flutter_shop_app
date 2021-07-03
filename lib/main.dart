import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './provider/auth.dart';
import './screens/auth_screen.dart';
import './provider/orders.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './provider/cart.dart';
import './provider/products.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './color_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => Products("", '', []),
        update: (ctx, auth, prevProducts) => Products(
          auth.token,
          auth.userId,
          prevProducts == null ? [] : prevProducts.items,
        ),
      ),
      ChangeNotifierProvider(create: (_) => Cart()),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders("", '', []),
        update: (ctx, auth, prevOrders) => Orders(
          auth.token,
          auth.userId,
          prevOrders == null ? [] : prevOrders.orders,
        ),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (ctx, auth, _) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: primarySwatch,
          accentColor: accentColor,
          fontFamily: "Lato",
        ),
        home: auth.isAuth
            ? ProductsOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authSnapshot) =>
                    authSnapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        routes: {
          // '/': (_) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          UserProductsScreen.routeName: (_) => UserProductsScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen(),
        },
      );
    });
  }
}
