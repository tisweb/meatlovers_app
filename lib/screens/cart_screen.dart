import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/orders.dart';
import '../screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  final thankYouImageUrl =
      'https://i.pinimg.com/564x/23/64/d0/2364d0101d34848fc9284b36f49ef7d5.jpg';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Spacer(),
                  Chip(
                    label: Text(
                      '\₹${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: cart.totalAmount > 0
                ? ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) => CartItem(
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].id,
                        cart.items.values.toList()[i].weight,
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                        cart.items.values.toList()[i].title,
                        'Y'),
                  )
                : FlatButton(
                    child: Text(
                      'Continue Shopping!!',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
          ),
          // OrderButton(cart: cart),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('CHECKOUT'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              Navigator.of(context).pushNamed(CheckoutScreen.routeName);
            },

      //following code was part of else part
      // () async {
      //     setState(() {
      //       _isLoading = true;
      //     });
      //     await Provider.of<Orders>(context, listen: false).addOrder(
      //       widget.cart.items.values.toList(),
      //       widget.cart.totalAmount,
      //     );

      //     setState(() {
      //       _isLoading = false;
      //     });
      //     widget.cart.clearCart();
      //   },
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
    );
  }
}
