import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../provider/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/carosel.dart';
import '../widgets/categories_grid.dart';
import '../provider/categories.dart';
import '../provider/carosel_items.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Categories>(context).fetchAndSetCategories().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<CaroselItems>(context).fetchAndSetCaroselItems().then((_) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Meat Lovers'),
        // actions: <Widget>[
        //   Consumer<Cart>(
        //     builder: (_, cart, ch) => Badge(
        //       child: ch,
        //       value: cart.itemCount.toString(),
        //     ),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.shopping_cart,
        //       ),
        //       onPressed: () {
        //         Navigator.of(context).pushNamed(CartScreen.routeName);
        //       },
        //     ),
        //   ),
        // ],
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Carosel(),
          ),
          Container(
            width: 10,
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            child: Text(
              'Shop By Category',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CategoriesGrid(),
          ),
        ],
      ),
      // body: CategoriesGrid(),
    );
  }
}
