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
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:image/image.dart' as img;

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  CameraController? controller;
  late List<CameraDescription> cameras;
  DetectedImageModel currentImage = DetectedImageModel();
  List<DetectedImageModel> images = [];
  late String flashMode;
  bool focusTaped = false;

  // how much 90 degrees rotation
  int cameraRotation = 0;

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
    await processImage();
    images.add(currentImage);
    currentImage = DetectedImageModel();
    emit(AddCurrentImageSuccessState());
  }

  // detect edges for the image
  Future<void> detectEdges() async {
    if (currentImage.imagePath == null) {
      return;
    }
    currentImage.edgeDetectionResult =
        await EdgeDetector().detectEdges(currentImage.imagePath!);
  }

  // crop image
  Future<void> processImage() async {
    if (currentImage.imagePath == null) {
      return;
    }
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/${DateTime.now()}.jpg';
    // await Directory(dirPath).create(recursive: true);
    log("process image function filepath1 ${currentImage.imagePath}");
    log("process image function dirpath2 ${dirPath}");
    await File(currentImage.imagePath!).copy(dirPath);
    bool result = await EdgeDetector()
        .processImage(dirPath, currentImage.edgeDetectionResult!);

    if (result == false) {
      return;
    }
    imageCache.clearLiveImages();
    imageCache.clear();
    currentImage.croppedImagePath = dirPath!;
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
      filePath = await resizePhoto(filePath);

      // rotate if needed
      if(cameraRotation != 0 ){
        rotateImage(filePath, cameraRotation*-90);
      }

    } on CameraException catch (e) {
      log(e.toString());
      return;
    }
    currentImage.imagePath = filePath;
  }

  // rotate image with path and angle
  Future<void> rotateImage(String imagePath, int angle) async {
    log("the angle = $angle");
    File croppedImage = File(imagePath);

    final img.Image? capturedImage =
        img.decodeImage(await croppedImage.readAsBytes());

    img.Image newImage = img.copyRotate(
      capturedImage!,
      angle,
    );

    final fixedFile = await croppedImage.writeAsBytes(img.encodePng(newImage));
  }

  // resize the image to fit the 4/3 aspect ratio
  Future<String> resizePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int width = properties.width!;
    var offset = (properties.height! - 4 / 3 * properties.width!) / 2;

    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, 0, offset.round(), width, (4 * width ~/ 3));

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
  void detectCameraRotation(DeviceOrientation? deviceOrientation) {
    if (deviceOrientation == null) {
      return;
    }
    switch (deviceOrientation) {
      case DeviceOrientation.portraitUp:
        cameraRotation = 0;
        break;
      case DeviceOrientation.landscapeRight:
        cameraRotation = 1;
        break;
      case DeviceOrientation.landscapeLeft:
        cameraRotation = -1;
        break;
      case DeviceOrientation.portraitDown:
        cameraRotation = 0;
        break;
    }
  }

  // cubit
  @override
  void onChange(Change<CameraState> change) {
    super.onChange(change);
    print(change);
  }
}
