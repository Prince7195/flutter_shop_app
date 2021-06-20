import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text(product.title),
      ),
    );
  }
}