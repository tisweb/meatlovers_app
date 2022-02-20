import 'package:flutter/foundation.dart';

class CaroselItem with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;

  CaroselItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });
}
