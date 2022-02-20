import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/categories.dart';
import '../widgets/manage_category_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_category_screen.dart';

class ManageCategoriesScreen extends StatelessWidget {
  static const routeName = '/manage-categories';

  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Categories>(context, listen: false)
        .fetchAndSetCategories();
  }

  @override
  Widget build(BuildContext context) {
    // final categoriesData = Provider.of<Categories>(context, listen: true);
    // print('rebuilding..');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories!'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditCategoryScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshCategories(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshCategories(context),
                      color: Colors.blue,
                      child: Consumer<Categories>(
                        builder: (ctx, categoriesData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: categoriesData.items.length,
                              itemBuilder: (_, i) => Column(
                                    children: [
                                      ManageCategoryItem(
                                        categoriesData.items[i].id,
                                        categoriesData.items[i].title,
                                        categoriesData.items[i].imageUrl,
                                      ),
                                      Divider(),
                                    ],
                                  )),
                        ),
                      ),
                    ),
        ));
  }
}
