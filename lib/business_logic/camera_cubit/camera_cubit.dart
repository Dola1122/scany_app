import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/data/models/detected_image_model.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  CameraController? controller;
  late List<CameraDescription> cameras;
  DetectedImageModel currentImage = DetectedImageModel();
  List<DetectedImageModel> images = [];

  // initialize camera controller when go to camera preview
  Future<void> initializeController() async {
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
    } on CameraException catch (e) {
      log(e.toString());
      return;
    }
    currentImage.imagePath = filePath;
  }

  // resize the image to fit the 4/3 aspect ratio
  Future<String> resizePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int width = properties.width!;
    var offset = (properties.height! - 4/3 * properties.width!) / 2;


    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, 0, offset.round(), width, (4 * width ~/ 3));

    await File(filePath).delete();

    return croppedFile.path;
  }

  // cubit
  @override
  void onChange(Change<CameraState> change) {
    super.onChange(change);
    print(change);
  }
}
