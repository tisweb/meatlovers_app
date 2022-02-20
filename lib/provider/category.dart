import 'package:flutter/foundation.dart';

class Category with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;

  Category({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });
}
