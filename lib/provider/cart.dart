import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String weight;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.weight,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;

    // return
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String weight, double price, String title) {
    bool existingCatItemInd = false;
    String cartKey = '$productId$weight';

    _items.forEach((key, value) {
      if (key == cartKey) {
        existingCatItemInd = true;
      }
    });

    if (existingCatItemInd == true) {
      //change quantity

      _items.update(
        cartKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          weight: existingCartItem.weight,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        cartKey,
        () => CartItem(
          // id: DateTime.now().toString(),
          id: productId,
          title: title,
          quantity: 1,
          weight: weight,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String id) {
    // String cartKey = '$productId$weight';
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId, String weight) {
    String cartKey = '$productId$weight';
    if (!_items.containsKey(cartKey)) {
      return;
    }
    if (_items[cartKey].quantity > 1) {
      _items.update(
        cartKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          weight: existingCartItem.weight,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(cartKey);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
