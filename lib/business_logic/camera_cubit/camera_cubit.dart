import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  CameraController? controller;
  String? croppedImagePath;
  late List<CameraDescription> cameras;
  String? imagePath;
  EdgeDetectionResult? edgeDetectionResult;

  // initialize camera controller when go to camera preview
  Future<void> initializeController() async {
    cameras = await availableCameras();

    if (cameras.isEmpty) {
      log('No cameras detected');
      return;
    }

    controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await controller?.initialize();
    emit(ControllerInitializedState());
  }


  //crop image
  Future<void> processImage() async {
    if (imagePath == null) {
      return ;
    }
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/flutter_test2.jpg';
    // await Directory(dirPath).create(recursive: true);
    log("process image function filepath1 ${imagePath}");
    log("process image function dirpath2 ${dirPath}");
    await File(imagePath!).copy(dirPath);
    bool result =
    await EdgeDetector().processImage(dirPath, edgeDetectionResult!);

    if (result == false) {
      return ;
    }
      imageCache.clearLiveImages();
      imageCache.clear();
      croppedImagePath = dirPath!;
  }

  void popBack(context)async{

    Uint8List img = await File(croppedImagePath!).readAsBytes();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context, img);
    edgeDetectionResult = null;
    imagePath = null;
    croppedImagePath = null;
    // controller?.dispose();

  }

  @override
  void onChange(Change<CameraState> change) {
    super.onChange(change);
    print(change);
  }



}
