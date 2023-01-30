import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ImagesHelper {

  static Future<Uint8List?> getImageFromCamera() async {
    Uint8List? file = await _pickImage(ImageSource.camera);
    return file;
  }

  static Future<Uint8List?> getImageFromGallery() async {
    Uint8List? file = await _pickImage(ImageSource.gallery);
    return file;
  }

  static Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = source == ImageSource.camera
        ? await imagePicker.pickImage(
            source: source, imageQuality: 25, maxWidth: 1920, maxHeight: 1920)
        : await imagePicker.pickImage(
            source: source, maxWidth: 1920, maxHeight: 1920);

    if (file != null) {
      return await file.readAsBytes();
    }
    print("No Image Selected");
    return null;
  }
  // rotate image with path and angle
  static Future<void> rotateImage(String? imagePath, int angle) async {
    log("the angle = $angle");
    log("the imagePath = $imagePath");
    File croppedImage = File(imagePath!);

    Future<Directory> path = getTemporaryDirectory();

    final img.Image? capturedImage =
    img.decodeImage(await croppedImage.readAsBytes());

    img.Image newImage = img.copyRotate(
      capturedImage!,
      angle,
    );
    log("live images count = ${imageCache.liveImageCount}");

    imageCache.clearLiveImages();
    imageCache.clear();

    log("live images count = ${imageCache.liveImageCount}");

    final fixedFile = await croppedImage.writeAsBytes(img.encodeJpg(newImage));

    log("new image path = ${fixedFile.path}");
  }
}
