import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../provider/cart.dart' show Cart;
import '../widgets/cart_item_list.dart';
import '../provider/orders.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final thankYouImageUrl =
      'https://i.pinimg.com/564x/23/64/d0/2364d0101d34848fc9284b36f49ef7d5.jpg';

  var _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var _custName = '';
  var _custAddress = '';
  var _custPhoneNo = '';
  var _deliveryDateTime = '';

  var _deliveryDate = '';
  var _deliveryTime = '';

  @override
  void initState() {
    _deliveryDate = DateTime.now().toIso8601String().substring(0, 10);
    _deliveryTime = TimeOfDay.now().hour.toString() +
        ':' +
        TimeOfDay.now().minute.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            cart.totalAmount > 0
                ? Card(
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                'Total Orders : ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${cart.itemCount}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Spacer(),
                              Text(
                                'Amount  :  ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  '\₹${cart.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6
                                        .color,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Delivery Details:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                height: 400,
                                child: ListView(
                                  children: <Widget>[
                                    TextFormField(
                                      key: ValueKey('custName'),
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a name.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _custName = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      key: ValueKey('custAddress'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a address.';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Address',
                                      ),
                                      onSaved: (value) {
                                        _custAddress = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      key: ValueKey('custPhoneNo'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a phone only 10 digits.';
                                        }
                                        if (value.length != 10) {
                                          return 'Please enter correct phone no.';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                      ),
                                      onSaved: (value) {
                                        _custPhoneNo = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Choose Delivery Date & Time'),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 130,
                                          child: ListTile(
                                            title: Text(_deliveryDate),
                                            onTap: () async {
                                              DateTime date =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 2),
                                              );
                                              if (date != null) {
                                                setState(() {
                                                  _deliveryDate = date
                                                      .toIso8601String()
                                                      .substring(0, 10);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 90,
                                          child: ListTile(
                                            title: Text(_deliveryTime),
                                            onTap: () async {
                                              TimeOfDay time =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (time != null) {
                                                setState(() {
                                                  _deliveryTime = time.hour
                                                          .toString() +
                                                      ':' +
                                                      time.minute.toString();
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('PLACE ORDER'),
                            onPressed: (cart.totalAmount <= 0 || _isLoading)
                                ? null
                                : () async {
                                    final isValid =
                                        _formKey.currentState.validate();
                                    FocusScope.of(context).unfocus();
                                    if (isValid) {
                                      _deliveryDateTime =
                                          _deliveryDate + ' - ' + _deliveryTime;
                                      _formKey.currentState.save();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await Provider.of<Orders>(context,
                                              listen: false)
                                          .addOrder(
                                        cart.items.values.toList(),
                                        cart.totalAmount,
                                        _custName,
                                        _custAddress,
                                        _custPhoneNo,
                                        _deliveryDateTime,
                                      );
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      cart.clearCart();
                                    }
                                  },
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Image.network(
                        thankYouImageUrl,
                        fit: BoxFit.cover,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Text('Continue Shopping'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
