import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './carosel_item.dart';
import '../models/http_exception.dart';

class CaroselItems with ChangeNotifier {
  List<CaroselItem> _items = [];

  final String authToken;
  CaroselItems(this.authToken, this._items);

  List<CaroselItem> get items {
    return [..._items];
  }

  CaroselItem finById(String id) {
    return _items.firstWhere((crsl) => crsl.id == id);
  }

  CaroselItem finByTitle(String title) {
    return _items.firstWhere((crsl) => crsl.title == title);
  }

  Future<void> fetchAndSetCaroselItems() async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/caroselitem.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extracedData = json.decode(response.body) as Map<String, dynamic>;
      if (extracedData == null) {
        return;
      }

      final List<CaroselItem> loadedCaroselItems = [];
      extracedData.forEach((crslId, crslData) {
        loadedCaroselItems.add(CaroselItem(
          id: crslId,
          title: crslData['title'],
          imageUrl: crslData['imageUrl'],
        ));
      });
      _items = loadedCaroselItems;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addCaroselItem(CaroselItem caroselItem) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/caroselitem.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': caroselItem.title,
          'imageUrl': caroselItem.imageUrl,
        }),
      );
      final newCaroselItem = CaroselItem(
        title: caroselItem.title,
        imageUrl: caroselItem.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCaroselItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCaroselItem(String id, CaroselItem newCaroselItem) async {
    final crslIndex = _items.indexWhere((crsl) => crsl.id == id);
    if (crslIndex >= 0) {
      final url =
          'https://meatlovers-5d6fe.firebaseio.com/caroselitem/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newCaroselItem.title,
            'imageUrl': newCaroselItem.imageUrl,
          }));
      _items[crslIndex] = newCaroselItem;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCaroselItem(String id) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/caroselitem/$id.json?auth=$authToken';
    final existingCaroselItemIndex = _items.indexWhere((crsl) => crsl.id == id);
    var existingCaroselItem = _items[existingCaroselItemIndex];
    _items.removeAt(existingCaroselItemIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingCaroselItemIndex, existingCaroselItem);
      notifyListeners();
      throw HttpException('Could not delete CaroselItem!');
    }
    existingCaroselItem = null;
  }
}
