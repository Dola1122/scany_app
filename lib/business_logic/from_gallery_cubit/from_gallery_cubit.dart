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
import 'package:scany/data/models/image_model.dart';
import 'package:scany/core/utils/edge_detection_helper.dart';
import 'package:scany/core/utils/images_helper.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:image/image.dart' as img;

part 'from_gallery_state.dart';

class FromGalleryCubit extends Cubit<FromGalleryState> {
  FromGalleryCubit() : super(FromGalleryInitial());

  ImageModel currentImage = ImageModel();
  List<ImageModel> images = [];
  int currentImageIndex = 0;

  // pick images from gallery
  pickImagesFromGallery(context) async {
    List<XFile> imageFileList = await ImagesHelper.pickMultipleImages();
    if (imageFileList.isEmpty) {
      popBack(context);
    }
    images = await Future.wait(imageFileList.map((element) async {
      ImageModel model = ImageModel();
      model.imagePath = element.path;
      await model.detectCurrentImageEdges();
      await model.cropDetectedImage();
      return model;
    }).toList());
    emit(FromGalleryImagesPickedState());
  }

  // regular pop to new pdf screen
  void popBack(context) async {
    Navigator.pop(context);
    currentImage = ImageModel();
    images = [];
  }

  // new pop after take all images and apply all filters
  void addSelectedImages(context) async {
    Navigator.pop(context, images);
    currentImage = ImageModel();
    images = [];
    currentImageIndex = 0;
  }

  // rotate image model
  Future<void> rotateImageModel(angle) async {
    await currentImage.rotateImageModel(angle);
    emit(ImageModelRotatedState());
  }

  Future<void> rotateImageModelWithIndex(angle) async {
    await images[currentImageIndex].rotateImageModel(angle);
    emit(ImageModelRotatedState());
  }

  void toggleDetection() {
    images[currentImageIndex].toggleDetection();
    emit(ToggleDetectionState());
  }

  // cubit
  @override
  void onChange(Change<FromGalleryState> change) {
    super.onChange(change);
    print(change);
  }
}
