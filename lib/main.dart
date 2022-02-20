import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './provider/products.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './provider/carosel_items.dart';
import './screens/manage_carosel_items_screen.dart';
import './screens/edit_carosel_item_screen.dart';
import './provider/categories.dart';
import './screens/edit_category_screen.dart';
import './screens/manage_categories_screen.dart';
import './screens/contacts_screen.dart';
import './screens/checkout_screen.dart';
import './screens/myaccount.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              auth.email,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Categories>(
            create: null,
            update: (ctx, auth, previousCategories) => Categories(
              auth.token,
              previousCategories == null ? [] : previousCategories.items,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, CaroselItems>(
            create: null,
            update: (ctx, auth, previousCaroselItems) => CaroselItems(
              auth.token,
              previousCaroselItems == null ? [] : previousCaroselItems.items,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Meat Lovers',
            theme: ThemeData(
              // primarySwatch: Colors.red,
              primaryColor: Colors.redAccent[700],
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                // ? ProductsOverviewScreens()
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            debugShowCheckedModeBanner: false,
            routes: {
              ProductsOverviewScreens.routeName: (ctx) =>
                  ProductsOverviewScreens(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ManageCategoriesScreen.routeName: (ctx) =>
                  ManageCategoriesScreen(),
              EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
              ManageCaroselItemsScreen.routeName: (ctx) =>
                  ManageCaroselItemsScreen(),
              EditCaroselItemScreen.routeName: (ctx) => EditCaroselItemScreen(),
              ContactsScreen.routeName: (ctx) => ContactsScreen(),
              CheckoutScreen.routeName: (ctx) => CheckoutScreen(),
              MyAccoutnScreen.routeName: (ctx) => MyAccoutnScreen(),
            },
          ),
        ));
  }
}
