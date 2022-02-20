import 'package:flutter/material.dart';
import 'package:meatlovers_app/screens/product_detail_screen.dart';

import 'package:provider/provider.dart';

import '../provider/category.dart';
import '../screens/products_overview_screen.dart';
// import '../screens/product_select_screen.dart';

class CategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Category>(
      builder: (ctx, category, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed(
              //   ProductSelectScreen.routeName,
              //   arguments: category.id,
              // );
              Navigator.of(context).pushNamed(ProductsOverviewScreens.routeName,
                  arguments: category.title);
            },
            child: Image.network(
              category.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: Opacity(
            opacity: 0.9,
            child: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(
                category.title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
