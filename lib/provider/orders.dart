import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final String name;
  final String address;
  final String phoneNo;
  final String deliveryDateTime;
  // final String deliveryTime;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.name,
    @required this.address,
    @required this.phoneNo,
    @required this.deliveryDateTime,
    // @required this.deliveryTime,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  final String email;
  Orders(this.authToken, this.userId, this.email, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String adminEmail = "admin@meatlovers.com";

  Future<void> fetchAndSetOrders() async {
    final filterString =
        adminEmail != email ? 'orderBy="userId"&equalTo="$userId"' : '';

    final url =
        'https://meatlovers-5d6fe.firebaseio.com/orders.json?auth=$authToken&$filterString';

    // final url =
    //     'https://meatlovers-5d6fe.firebaseio.com/orders.json?auth=$authToken&$filterString';

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    // final noOfOrders = extractedData.length;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          name: orderData['name'],
          address: orderData['address'],
          phoneNo: orderData['phoneNo'],
          deliveryDateTime: orderData['deliveryDateTime'],

          // deliveryTime: orderData['deliveryTime'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  weight: item['weight'],
                  price: item['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
    String name,
    String address,
    String phoneNo,
    String deliveryDateTime,
    // String deliveryTime,
  ) async {
    // final url =
    //     'https://meatlovers-5d6fe.firebaseio.com/orders/$userId.json?auth=$authToken';
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'name': name,
        'address': address,
        'phoneNo': phoneNo,
        'deliveryDateTime': deliveryDateTime,
        // 'deliveryTime': deliveryTime,
        'userId': userId,
        'products': cartProducts
            .map((cartProducts) => {
                  'id': cartProducts.id,
                  'title': cartProducts.title,
                  'quantity': cartProducts.quantity,
                  'weight': cartProducts.weight,
                  'price': cartProducts.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        name: name,
        address: address,
        phoneNo: phoneNo,
        deliveryDateTime: deliveryDateTime,
        // deliveryTime: deliveryTime,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
