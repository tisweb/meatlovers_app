import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:meatlovers_app/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/detail_item.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);

  static const routeName = '/product-detail';

  // @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   bool _checked = true;
  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the ID
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).finById(productId);
    // final String itemKey1 = '$productId${loadedProduct.weight1}';
    // final String itemKey2 = '$productId${loadedProduct.weight2}';
    // final String itemKey3 = '$productId${loadedProduct.weight3}';
    // bool itemKeyInd1 = false;
    // bool itemKeyInd2 = false;
    // bool itemKeyInd3 = false;
    // cart.items.forEach((key, value) {
    //   if (key == itemKey1) {
    //     itemKeyInd1 = true;
    //   }
    //   if (key == itemKey2) {
    //     itemKeyInd2 = true;
    //   }
    //   if (key == itemKey3) {
    //     itemKeyInd3 = true;
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: <Widget>[
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
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      body: DetailItem(),

      // following code is now moved to detail item widget
      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 300,
      //         width: double.infinity,
      //         child: Image.network(
      //           loadedProduct.imageUrl,
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: <Widget>[
      //           Text('Weight : ${loadedProduct.weight1}'),
      //           Text('Rate : ${loadedProduct.price1}'),
      //           Flexible(
      //             // child: CheckboxListTile(
      //             //   title: Text(
      //             //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
      //             //   controlAffinity: ListTileControlAffinity.trailing,
      //             //   value: _checked,
      //             //   onChanged: (bool value) {
      //             //     print(value);
      //             //     setState(() {
      //             //       _checked = value;
      //             //     });
      //             //   },
      //             // ),
      //             // child: IconButton(
      //             //   icon: Icon(
      //             //     Icons.shopping_cart,
      //             //   ),
      //             //   onPressed: () {
      //             //     cart.addItem(productId, loadedProduct.weight1,
      //             //         loadedProduct.price1, loadedProduct.title);
      //             //   },
      //             //   color: Theme.of(context).accentColor,
      //             // ),
      //             child: itemKeyInd1
      //                 ? SizedBox(
      //                     width: 100,
      //                     height: 30,
      //                     child: Row(
      //                       children: <Widget>[
      //                         IconButton(
      //                           icon: Icon(Icons.remove_circle),
      //                           color: Theme.of(context).primaryColor,
      //                           onPressed: () {
      //                             cart.removeSingleItem(
      //                                 productId, loadedProduct.weight1);
      //                             print('checkerre4');
      //                           },
      //                         ),
      //                         IconButton(
      //                           icon: Icon(Icons.add_circle),
      //                           color: Theme.of(context).primaryColor,
      //                           onPressed: () {
      //                             cart.addItem(
      //                                 productId,
      //                                 loadedProduct.weight1,
      //                                 loadedProduct.price1,
      //                                 loadedProduct.title);
      //                             print('checkerre3');
      //                           },
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 : FlatButton(
      //                     child: Text('ADD'),
      //                     color: Theme.of(context).primaryColor,
      //                     textColor: Colors.white,
      //                     onPressed: () {
      //                       cart.addItem(productId, loadedProduct.weight1,
      //                           loadedProduct.price1, loadedProduct.title);
      //                       print('checkerre2');
      //                     },
      //                   ),
      //           )
      //         ],
      //       ),
      //       SizedBox(height: 5),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: <Widget>[
      //           Text('Weight : ${loadedProduct.weight2}'),
      //           Text('Rate : ${loadedProduct.price2}'),
      //           Flexible(
      //             // child: CheckboxListTile(
      //             //   title: Text(
      //             //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
      //             //   controlAffinity: ListTileControlAffinity.trailing,
      //             //   value: _checked,
      //             //   onChanged: (bool value) {
      //             //     print(value);
      //             //     setState(() {
      //             //       _checked = value;
      //             //     });
      //             //   },
      //             // ),
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.shopping_cart,
      //               ),
      //               onPressed: () {
      //                 cart.addItem(productId, loadedProduct.weight2,
      //                     loadedProduct.price2, loadedProduct.title);
      //               },
      //               color: Theme.of(context).accentColor,
      //             ),
      //           )
      //         ],
      //       ),
      //       SizedBox(height: 5),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: <Widget>[
      //           Text('Weight : ${loadedProduct.weight3}'),
      //           Text('Rate : ${loadedProduct.price3}'),
      //           Flexible(
      //             // child: CheckboxListTile(
      //             //   title: Text(
      //             //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
      //             //   controlAffinity: ListTileControlAffinity.trailing,
      //             //   value: _checked,
      //             //   onChanged: (bool value) {
      //             //     print(value);
      //             //     setState(() {
      //             //       _checked = value;
      //             //     });
      //             //   },
      //             // ),
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.shopping_cart,
      //               ),
      //               onPressed: () {
      //                 cart.addItem(productId, loadedProduct.weight3,
      //                     loadedProduct.price3, loadedProduct.title);
      //               },
      //               color: Theme.of(context).accentColor,
      //             ),
      //           )
      //         ],
      //       ),
      //       // Row(
      //       //   mainAxisAlignment: MainAxisAlignment.start,
      //       //   children: <Widget>[
      //       //     SizedBox(width: 10),
      //       //     Text(
      //       //       '\$${loadedProduct.price1}',
      //       //       style: TextStyle(
      //       //         color: Colors.grey,
      //       //         fontSize: 20,
      //       //       ),
      //       //     ),
      //       //   ],
      //       // ),
      //       SizedBox(height: 10),
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 10),
      //         width: double.infinity,
      //         child: Text(
      //           loadedProduct.description,
      //           textAlign: TextAlign.left,
      //           softWrap: true,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
