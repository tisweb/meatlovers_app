import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/carosel_items.dart';
import '../widgets/manage_carosel_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_carosel_item_screen.dart';

class ManageCaroselItemsScreen extends StatelessWidget {
  static const routeName = '/manage-carosel_items';

  Future<void> _refreshCaroselItems(BuildContext context) async {
    await Provider.of<CaroselItems>(context, listen: false)
        .fetchAndSetCaroselItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carosel Items!'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCaroselItemScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCaroselItems(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCaroselItems(context),
                    color: Colors.blue,
                    child: Consumer<CaroselItems>(
                      builder: (ctx, caroselItemsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: caroselItemsData.items.length,
                            itemBuilder: (_, i) => Column(
                                  children: [
                                    ManageCaroselItem(
                                      caroselItemsData.items[i].id,
                                      caroselItemsData.items[i].title,
                                      caroselItemsData.items[i].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
