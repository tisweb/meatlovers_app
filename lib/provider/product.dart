import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String categoryTitle;
  final String title;
  final String description;
  final String weight1;
  final String weight2;
  final String weight3;
  final double price1;
  final double price2;
  final double price3;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.categoryTitle,
    @required this.title,
    @required this.description,
    @required this.weight1,
    @required this.weight2,
    @required this.weight3,
    @required this.price1,
    @required this.price2,
    @required this.price3,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/useFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
