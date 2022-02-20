import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './category.dart';
import '../models/http_exception.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [
    // Category(
    //   id: 'b1',
    //   title: 'Chicken',
    //   imageUrl: 'assets/images/B001.jpg',
    // ),
    // Category(
    //   id: 'n1',
    //   title: 'Nattu Koli',
    //   imageUrl: 'assets/images/N001.jpg',
    // ),
    // Category(
    //   id: 'm1',
    //   title: 'Mutton',
    //   imageUrl: 'assets/images/M001.jpg',
    // ),
  ];

  final String authToken;
  Categories(this.authToken, this._items);

  List<Category> get items {
    return [..._items];
  }

  Category finById(String id) {
    return _items.firstWhere((cat) => cat.id == id);
  }

  Category finByTitle(String title) {
    return _items.firstWhere((cat) => cat.title == title);
  }

  Future<void> fetchAndSetCategories() async {
    // final filterString =
    //     filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extracedData = json.decode(response.body) as Map<String, dynamic>;
      if (extracedData == null) {
        return;
      }

      final List<Category> loadedCategories = [];
      extracedData.forEach((catId, catData) {
        loadedCategories.add(Category(
          id: catId,
          title: catData['title'],
          imageUrl: catData['imageUrl'],
        ));
      });
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addCategory(Category category) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': category.title,
          'imageUrl': category.imageUrl,
        }),
      );
      final newCategory = Category(
        title: category.title,
        imageUrl: category.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCategory);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCategory(String id, Category newCategory) async {
    final catIndex = _items.indexWhere((cat) => cat.id == id);
    if (catIndex >= 0) {
      final url =
          'https://meatlovers-5d6fe.firebaseio.com/categories/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newCategory.title,
            'imageUrl': newCategory.imageUrl,
          }));
      _items[catIndex] = newCategory;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCategory(String id) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/categories/$id.json?auth=$authToken';
    final existingCategoryIndex = _items.indexWhere((cat) => cat.id == id);
    var existingCategory = _items[existingCategoryIndex];
    _items.removeAt(existingCategoryIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
      throw HttpException('Could not delete category!');
    }
    existingCategory = null;
  }
}
