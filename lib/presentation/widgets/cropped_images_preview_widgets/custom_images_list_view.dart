import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scany/data/models/image_model.dart';

class CustomImagesListView extends StatelessWidget {
  const CustomImagesListView({
    Key? key,
    required this.onPageChanged,
    required this.numberOfItems,
    required this.imageModels,
  }) : super(key: key);

  final Function(int, CarouselPageChangedReason) onPageChanged;
  final int numberOfItems;
  final List<ImageModel> imageModels;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          height: double.infinity,
          onPageChanged: onPageChanged,
          // viewportFraction: 0.9,
          // aspectRatio: 2.0,
          // initialPage: 2,
        ),
        itemCount: numberOfItems,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return Center(
            child: Image.file(
              File(
                imageModels[itemIndex].croppedImagePath!,
              ),
              fit: BoxFit.contain,
              key: GlobalKey(),
            ),
          );
        },
      ),
    );
  }
}
