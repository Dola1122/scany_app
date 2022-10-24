import 'dart:typed_data';

import 'package:flutter/material.dart';

class EditPhotoScreen extends StatefulWidget {
  final Uint8List image;

  const EditPhotoScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: SizedBox(
        width: double.infinity,
        child: Image.memory(widget.image, fit: BoxFit.contain),
      )),
    );
  }
}
