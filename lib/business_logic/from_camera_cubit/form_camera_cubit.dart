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

part 'from_camera_state.dart';

class FromCameraCubit extends Cubit<FromCameraState> {
  FromCameraCubit() : super(CameraInitial());

  CameraController? controller;
  late List<CameraDescription> cameras;
  DetectedImageModel currentImage = DetectedImageModel();
  List<DetectedImageModel> images = [];
  late String flashMode;
  bool focusTaped = false;
  int currentImageIndex = 0;

  // how much 90 degrees rotation
  int cameraRotation = 0;
  DeviceOrientation currentCameraOrientation = DeviceOrientation.portraitUp;

  // initialize camera controller when go to camera preview
  Future<void> initializeController() async {
    flashMode = "auto";
    cameras = await availableCameras();

    if (cameras.isEmpty) {
      log('No cameras detected');
      return;
    }

    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    await controller?.initialize();
    emit(ControllerInitializedState());
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
    controller?.dispose();
    controller = null;
  }

  // new pop after take all images and apply all filters
  void newPopBack(context) async {
    Navigator.pop(context);
    Navigator.pop(context, images);
    currentImage = DetectedImageModel();
    images = [];
    controller?.dispose();
    controller = null;
  }

  // take image by camera controller
  Future<void> takePicture() async {
    currentImage = DetectedImageModel();
    if (!controller!.value.isInitialized) {
      log('Error: select a camera first.');
      return;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    String? filePath;

    if (controller!.value.isTakingPicture) {
      return;
    }

    try {
      XFile image = await controller!.takePicture();
      filePath = image.path;
      if (currentCameraOrientation == DeviceOrientation.portraitUp) {
        filePath = await resizePortraitPhoto(filePath);
      } else {
        filePath = await resizeLandscapePhoto(filePath);
      }
    } on CameraException catch (e) {
      log(e.toString());
      return;
    }
    currentImage.imagePath = filePath;
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

  // camera refocus to the middle of the camera (0.5 , 0.5)
  Future<void> focus() async {
    await controller!.setFocusPoint(null);
    await controller!.setFocusPoint(const Offset(0.5, 0.5));
    await focusSquareAppearance();
  }

  // focus square appear
  Future<void> focusSquareAppearance() async {
    focusTaped = true;
    emit(CameraStartFocusState());
    await Future.delayed(const Duration(milliseconds: 1500));
    focusTaped = false;
    emit(CameraEndFocusState());
  }

  // flash mode pop up menu icon
  Icon flashModeIcon() {
    switch (flashMode) {
      case "auto":
        return const Icon(Icons.flash_auto);
      case "on":
        return const Icon(Icons.flash_on);
      case "off":
        return const Icon(Icons.flash_off);
    }
    return const Icon(Icons.flash_off);
  }

  // flash mode pop up menu logic
  void changeFlashMode(int value) {
    switch (value) {
      case 1:
        flashMode = "auto";
        break;
      case 2:
        flashMode = "on";
        break;
      case 3:
        flashMode = "off";
        break;
    }
    setFlashMode();
    emit(CameraChangeFlashModeState());
  }

  // change camera flash mode
  Future<void> setFlashMode() async {
    switch (flashMode) {
      case "auto":
        await controller!.setFlashMode(FlashMode.auto);
        break;
      case "on":
        await controller!.setFlashMode(FlashMode.always);
        break;
      case "off":
        await controller!.setFlashMode(FlashMode.off);
        break;
    }
  }

  // detect camera rotation
  Future<void> detectCameraRotation(
      DeviceOrientation? deviceOrientation) async {
    if (deviceOrientation == null) {
      return;
    }
    if (deviceOrientation != currentCameraOrientation) {
      currentCameraOrientation = deviceOrientation;
      emit(CameraRotatedState());
    }
    switch (deviceOrientation) {
      case DeviceOrientation.portraitUp:
        await controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
        cameraRotation = 0;
        break;
      case DeviceOrientation.landscapeRight:
        await controller
            ?.lockCaptureOrientation(DeviceOrientation.landscapeLeft);

        cameraRotation = 1;
        break;
      case DeviceOrientation.landscapeLeft:
        await controller
            ?.lockCaptureOrientation(DeviceOrientation.landscapeRight);

        cameraRotation = -1;
        break;
      case DeviceOrientation.portraitDown:
        cameraRotation = 0;
        break;
    }
  }

  void toggleDetection() {
    currentImage.toggleDetection();
    emit(ToggleDetectionState());
  }

  // cubit
  @override
  void onChange(Change<FromCameraState> change) {
    super.onChange(change);
    print(change);
  }
}
