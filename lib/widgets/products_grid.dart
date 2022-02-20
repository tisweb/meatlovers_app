import 'package:flutter/material.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  // final bool showOnlyFavorites;
  final String categoryTitle;

  ProductsGrid(this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<Products>(context);
    final products = productsDate.productsByCategoryTitle(categoryTitle);
    // print(categoryTitle);
    // print(products[0].catId);
    // final products =
    //     showOnlyFavorites ? productsDate.favorietItem : productsDate.items;
    return products.length > 0
        ? GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(
                  // products[i].id,
                  // products[i].title,
                  // products[i].imageUrl,
                  ),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          )
        : Center(
            child: Text(
            'Products beeing added in this category! Please visit again later!',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ));
  }
}
