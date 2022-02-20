import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavouritesOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  // List<Product> productsByCategory(String categoryId) {
  //   return _items.where((prod) => prod.catId == categoryId).toList();
  // }

  List<Product> productsByCategoryTitle(String categoryTitle) {
    return _items.where((prod) => prod.categoryTitle == categoryTitle).toList();
  }

  List<Product> get favorietItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product finById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showFavoritesAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url =
        'https://meatlovers-5d6fe.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extracedData = json.decode(response.body) as Map<String, dynamic>;
      if (extracedData == null) {
        return;
      }
      url =
          'https://meatlovers-5d6fe.firebaseio.com/useFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteDate = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extracedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          categoryTitle: prodData['categoryTitle'],
          title: prodData['title'],
          weight1: prodData['weight1'],
          weight2: prodData['weight2'],
          weight3: prodData['weight3'],
          price1: prodData['price1'],
          price2: prodData['price2'],
          price3: prodData['price3'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteDate == null ? false : favoriteDate[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'categoryTitle': product.categoryTitle,
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'weight1': product.weight1,
          'weight2': product.weight2,
          'weight3': product.weight3,
          'price1': product.price1,
          'price2': product.price2,
          'price3': product.price3,
          'userId': userId,
        }),
      );
      final newProduct = Product(
        categoryTitle: product.categoryTitle,
        title: product.title,
        description: product.description,
        weight1: product.weight1,
        weight2: product.weight2,
        weight3: product.weight3,
        price1: product.price1,
        price2: product.price2,
        price3: product.price3,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // .then((response) { this line is not needed if we use async and await
    // print(json.decode(response.body));
    //JSON = JavaScript Object Notation;

    // final newProduct = Product(
    //   title: product.title,
    //   description: product.description,
    //   price: product.price,
    //   imageUrl: product.imageUrl,
    //   id: json.decode(response.body)['name'],
    // );
    // _items.add(newProduct);
    // _items.insert(0, newProduct); //add at the start of the list
    // notifyListeners();
    // }).catchError((error) { these lines of codes are not needed if we use async and await
    //   print(error);
    //   throw error;
    // });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://meatlovers-5d6fe.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'categoryTitle': newProduct.categoryTitle,
            'title': newProduct.title,
            'description': newProduct.description,
            'weight1': newProduct.weight1,
            'weight2': newProduct.weight2,
            'weight3': newProduct.weight3,
            'price1': newProduct.price1,
            'price2': newProduct.price2,
            'price3': newProduct.price3,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://meatlovers-5d6fe.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProduct = null;
  }
}
