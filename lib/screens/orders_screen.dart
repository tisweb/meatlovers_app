import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _orderFuture;
  var orderLenght;

  Future _obtainOrdersFuture() {
    final orders = Provider.of<Orders>(context, listen: false);
    // print('check order2 - length : ${orders.orders.length}');
    setState(() {
      orderLenght = orders.orders.length;
    });
    return orders.fetchAndSetOrders();
    // return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrdersFuture();
    // print('check order1 - length : $orderLenght');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderDataCheck = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //..
                // Do error handling stuff
                print(dataSnapshot.error);
                return Center(
                    child: Text('An error occurred! ${dataSnapshot.error}'));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          },
        )
        // : Center(child: Text('No Orders! Please Continue Shopping! ')),
        //  _isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : ListView.builder(
        //         itemCount: orderData.orders.length,
        //         itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        //       ),
        );
  }
}
