import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../provider/product.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = productsData.items;
    return GridView.builder(
      itemCount: loadedProducts.length,
      itemBuilder: (_, index) {
        final product = loadedProducts[index];
        return ProductItem(product.id, product.title, product.imageUrl);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
      ),
    );
  }
}
