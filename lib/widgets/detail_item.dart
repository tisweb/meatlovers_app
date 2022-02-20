import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../provider/cart.dart';

class DetailItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the ID
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).finById(productId);

    bool itemKeyInd1 = false;
    bool itemKeyInd2 = false;
    bool itemKeyInd3 = false;
    String itemKey1 = '$productId${loadedProduct.weight1}';
    String itemKey2 = '$productId${loadedProduct.weight2}';
    String itemKey3 = '$productId${loadedProduct.weight3}';

    cart.items.forEach((key, value) {
      if (key == itemKey1) {
        itemKeyInd1 = true;
      }
      if (key == itemKey2) {
        itemKeyInd2 = true;
      }
      if (key == itemKey3) {
        itemKeyInd3 = true;
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Weight : ${loadedProduct.weight1}          '),
              Text('Rate : ${loadedProduct.price1}'),
              Flexible(
                // child: CheckboxListTile(
                //   title: Text(
                //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _checked,
                //   onChanged: (bool value) {
                //     print(value);
                //     setState(() {
                //       _checked = value;
                //     });
                //   },
                // ),
                // child: IconButton(
                //   icon: Icon(
                //     Icons.shopping_cart,
                //   ),
                //   onPressed: () {
                //     cart.addItem(productId, loadedProduct.weight1,
                //         loadedProduct.price1, loadedProduct.title);
                //   },
                //   color: Theme.of(context).accentColor,
                // ),
                child: itemKeyInd1
                    ? SizedBox(
                        width: 100,
                        height: 35,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.removeSingleItem(
                                    productId, loadedProduct.weight1);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.addItem(productId, loadedProduct.weight1,
                                    loadedProduct.price1, loadedProduct.title);
                              },
                            ),
                          ],
                        ),
                      )
                    : FlatButton(
                        child: Text('ADD'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          cart.addItem(productId, loadedProduct.weight1,
                              loadedProduct.price1, loadedProduct.title);
                        },
                      ),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Weight : ${loadedProduct.weight2}'),
              Text('Rate : ${loadedProduct.price2}'),
              Flexible(
                // child: CheckboxListTile(
                //   title: Text(
                //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _checked,
                //   onChanged: (bool value) {
                //     print(value);
                //     setState(() {
                //       _checked = value;
                //     });
                //   },
                // ),
                child: itemKeyInd2
                    ? SizedBox(
                        width: 100,
                        height: 35,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.removeSingleItem(
                                    productId, loadedProduct.weight2);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.addItem(productId, loadedProduct.weight2,
                                    loadedProduct.price2, loadedProduct.title);
                              },
                            ),
                          ],
                        ),
                      )
                    : FlatButton(
                        child: Text('ADD'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          cart.addItem(productId, loadedProduct.weight2,
                              loadedProduct.price2, loadedProduct.title);
                        },
                      ),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Weight : ${loadedProduct.weight3}'),
              Text('Rate : ${loadedProduct.price3}'),
              Flexible(
                // child: CheckboxListTile(
                //   title: Text(
                //       '${loadedProduct.weight1}  ${loadedProduct.price1}'),
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _checked,
                //   onChanged: (bool value) {
                //     print(value);
                //     setState(() {
                //       _checked = value;
                //     });
                //   },
                // ),
                child: itemKeyInd3
                    ? SizedBox(
                        width: 100,
                        height: 35,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.removeSingleItem(
                                    productId, loadedProduct.weight3);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                size: 25,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                cart.addItem(productId, loadedProduct.weight3,
                                    loadedProduct.price3, loadedProduct.title);
                              },
                            ),
                          ],
                        ),
                      )
                    : FlatButton(
                        child: Text('ADD'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          cart.addItem(productId, loadedProduct.weight3,
                              loadedProduct.price3, loadedProduct.title);
                        },
                      ),
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     SizedBox(width: 10),
          //     Text(
          //       '\$${loadedProduct.price1}',
          //       style: TextStyle(
          //         color: Colors.grey,
          //         fontSize: 20,
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
