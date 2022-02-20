import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../provider/auth.dart';
import '../screens/manage_categories_screen.dart';
import '../screens/manage_carosel_items_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/myaccount.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final String adminEmail = "admin@meatlovers.com";
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Dashboard!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          auth.email != adminEmail
              ? Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_box,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('My Account'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(MyAccoutnScreen.routeName);
                      },
                    ),
                    Divider(),
                  ],
                )
              : Column(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          auth.email == adminEmail
              ? Column(
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Manage Categories'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            ManageCategoriesScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Manage Products'),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(UserProductsScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Manage Carosel Items'),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            ManageCaroselItemsScreen.routeName);
                      },
                    ),
                    // Divider(),
                  ],
                )
              : Column(),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.phone_iphone,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Contact Us'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ContactsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              // Provider.of<Auth>(context, listen: false).logout();

              // auth.logout();

              auth.logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
