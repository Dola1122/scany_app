import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final Uint8List image;
  final int index;

  const ImagePage({Key? key, required this.image, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.memory(image, fit: BoxFit.contain)),
        SizedBox(height: 5,),
        Text("${index + 1}",style: TextStyle(color: Colors.black54),),
        SizedBox(height: 5,),
      ],
    );
  }
}
