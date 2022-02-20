import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../provider/carosel_items.dart';

// final List<String> imgList = [
//   'assets/images/B001.jpg',
//   'assets/images/M001.jpg',
//   'assets/images/N001.jpg',
// ];

class Carosel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caroselItemsData = Provider.of<CaroselItems>(context);
    final caroselItems = caroselItemsData.items;
    // print(caroselItems.length);
    // print(imageList[0].toString());
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: caroselItems
            .map((item) => Container(
                  child: Center(
                      child: Image.network(item.imageUrl,
                          fit: BoxFit.cover, width: 1000)),
                ))
            .toList(),
      ),
    );
  }
}
