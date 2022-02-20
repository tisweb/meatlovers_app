import 'package:flutter/material.dart';
import 'package:meatlovers_app/provider/categories.dart';

import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../provider/products.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreens extends StatefulWidget {
  static const routeName = '/product-overview';
  @override
  _ProductsOverviewScreensState createState() =>
      _ProductsOverviewScreensState();
}

class _ProductsOverviewScreensState extends State<ProductsOverviewScreens> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context, listen: false).fetchAndSetProducts(); This will also work fine (or)
    //below code will also work fine
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });

    super.initState();
  }

  //or below block will also work fine
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //  final productsContainer = Provider.of<Products>(context, listen: false);
    final categoryTitle = ModalRoute.of(context).settings.arguments as String;
    final loadedCategory = Provider.of<Categories>(context, listen: false)
        .finByTitle(categoryTitle);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedCategory.title),
        actions: <Widget>[
          // PopupMenuButton(
          //   onSelected: (FilterOptions selectedValue) {
          //     setState(() {
          //       if (selectedValue == FilterOptions.Favorites) {
          //         //  productsContainer.showFavoritesOnly();
          //         _showOnlyFavorites = true;
          //       } else {
          //         // productsContainer.showFavoritesAll();
          //         _showOnlyFavorites = false;
          //       }
          //     });
          //   },
          //   icon: Icon(
          //     Icons.more_vert,
          //   ),
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favorites'),
          //       value: FilterOptions.Favorites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FilterOptions.All,
          //     ),
          //   ],
          // ),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.itemCount.toString(),
                  ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed((CartScreen.routeName));
                },
              )),
        ],
      ),
      // drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          // : ProductsGrid(_showOnlyFavorites),
          : ProductsGrid(categoryTitle),
    );
  }
}
