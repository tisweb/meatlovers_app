import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../widgets/cart_item_list.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String weight;
  final double price;
  final int quantity;
  final String title;
  final String cartInd;

  CartItem(this.id, this.productId, this.weight, this.price, this.quantity,
      this.title, this.cartInd);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: cartInd == 'Y'
            ? (direction) {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                      'Do you want to remove item from the cart?',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                    ],
                  ),
                );
              }
            : null,
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(id);
        },
        child:
            CartItemList(id, productId, weight, price, quantity, title, cartInd)
        // Card(
        //   margin: EdgeInsets.symmetric(
        //     horizontal: 15,
        //     vertical: 4,
        //   ),
        //   child: Padding(
        //     padding: EdgeInsets.all(8),
        //     child: ListTile(
        //       leading: CircleAvatar(
        //         child: Padding(
        //           padding: EdgeInsets.all(2),
        //           child: FittedBox(
        //             child: Text('\₹$price'),
        //           ),
        //         ),
        //       ),
        //       title: Text(title),
        //       subtitle: Text('Total: \₹${price * quantity}'),
        //       trailing: cartInd == 'Y'
        //           ? Column(children: <Widget>[
        //               Text('($weight) $quantity x'),

        //               SizedBox(
        //                 width: 100,
        //                 height: 20,
        //                 child: Row(children: <Widget>[
        //                   IconButton(
        //                     icon: Icon(Icons.remove_circle),
        //                     color: Theme.of(context).primaryColor,
        //                     onPressed: () {
        //                       cart.removeSingleItem(productId, weight);
        //                     },
        //                   ),
        //                   IconButton(
        //                     icon: Icon(Icons.add_circle),
        //                     color: Theme.of(context).primaryColor,
        //                     onPressed: () {
        //                       cart.addItem(productId, weight, price, title);
        //                       print('cartitem $productId');
        //                     },
        //                   ),
        //                 ]),
        //               ),

        //               // Row(
        //               //   children: <Widget>[
        //               //     IconButton(
        //               //       icon: Icon(Icons.add_circle),
        //               //       onPressed: () {
        //               //         cart.addItem(productId, weight, price, title);
        //               //       },
        //               //     ),
        //               //   ],
        //               // )
        //             ])
        //           : Text('($weight) $quantity x'),
        //     ),
        //   ),
        // ),
        );
  }
}
