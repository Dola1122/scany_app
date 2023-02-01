import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/data/models/detected_image_model.dart';
import 'package:scany/data/repository/edge_detection_helper.dart';
import 'package:scany/data/repository/images_helper.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:image/image.dart' as img;

part 'from_gallery_state.dart';

class FromGalleryCubit extends Cubit<FromGalleryState> {
  FromGalleryCubit() : super(FromGalleryInitial());

  DetectedImageModel currentImage = DetectedImageModel();
  List<DetectedImageModel> images = [];
  int currentImageIndex = 0;

  // how much 90 degrees rotation
  int cameraRotation = 0;

  // pick images from gallery
  pickImagesFromGallery(context) async {
    List<XFile> imageFileList = await ImagesHelper.pickMultipleImages();
    if (imageFileList.isEmpty) {
      popBack(context);
    }
    images = await Future.wait(imageFileList.map((element) async {
      DetectedImageModel model = DetectedImageModel();
      model.imagePath = element.path;
      await model.detectCurrentImageEdges();
      await model.cropDetectedImage();
      return model;
    }).toList());
    emit(FromGalleryImagesPickedState());
  }

  // add current image and push to camera to take another image
  Future<void> addCurrentImage() async {
    await currentImage.cropDetectedImage();
    images.add(currentImage);
    currentImage = DetectedImageModel();
    emit(AddCurrentImageSuccessState());
  }

  // regular pop to new pdf screen
  void popBack(context) async {
    Navigator.pop(context);
    currentImage = DetectedImageModel();
    images = [];
  }

  // new pop after take all images and apply all filters
  void addSelectedImages(context) async {
    Navigator.pop(context, images);
    currentImage = DetectedImageModel();
    images = [];
  }

  // rotate image model
  Future<void> rotateImageModel(DetectedImageModel image, angle) async {
    if (image.imagePath != null) {
      await ImagesHelper.rotateImage(image.imagePath ?? "", angle);
    }
    if (image.croppedImagePath != null) {
      await ImagesHelper.rotateImage(image.croppedImagePath ?? "", angle);
    }
    emit(ImageModelRotatedState());
  }

  // resize the portrait image to fit the 4/3 aspect ratio
  Future<String> resizePortraitPhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int width = properties.width!;
    var offset = (properties.height! - 4 / 3 * properties.width!) / 2;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, 0, offset.round(), width, (4 * width ~/ 3));

    await File(filePath).delete();

    return croppedFile.path;
  }

  // resize the landscape image to fit the 4/3 aspect ratio
  Future<String> resizeLandscapePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int height = properties.height!;
    var offset = (properties.width! - 4 / 3 * properties.height!) / 2;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, offset.round(), 0, (4 * height ~/ 3), height);

    await File(filePath).delete();

    return croppedFile.path;
  }

  void toggleDetection() {
    currentImage.toggleDetection();
    emit(ToggleDetectionState());
  }

  // cubit
  @override
  void onChange(Change<FromGalleryState> change) {
    super.onChange(change);
    print(change);
  }
}
