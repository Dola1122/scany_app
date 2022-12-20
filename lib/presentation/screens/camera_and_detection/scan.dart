import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_view.dart';
import 'cropping preview.dart';
import 'edge_detector.dart';
import 'image_view.dart';

// home page
class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  CameraController? controller;
  String? croppedImagePath;
  late List<CameraDescription> cameras;
  String? imagePath;
  EdgeDetectionResult? edgeDetectionResult;

  @override
  void initState() {
    super.initState();
    checkForCameras().then((value) {
      _initializeController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              if (croppedImagePath == null) {
                await _processImage(imagePath!, edgeDetectionResult!);
                Uint8List img = await File(croppedImagePath!).readAsBytes();
                Navigator.pop(context, img);
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _getMainWidget(),
          _getBottomBar(),
        ],
      ),
    );
  }

  Widget _getMainWidget() {
    if (croppedImagePath != null) {
      return ImageView(imagePath: croppedImagePath!);
    }

    if (imagePath == null && edgeDetectionResult == null) {
      if (controller == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return CameraView(controller: controller!);
    }

    return ImagePreview(
      imagePath: imagePath,
      edgeDetectionResult: edgeDetectionResult,
    );
  }

  Future<void> checkForCameras() async {
    cameras = await availableCameras();
  }

  void _initializeController() {
    if (cameras.isEmpty) {
      log('No cameras detected');
      return;
    }

    controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    String? filePath;

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile image = await controller!.takePicture();
      filePath = image.path;
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
    return filePath;
  }

  Padding _getBottomBar() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child:
            Align(alignment: Alignment.bottomCenter, child: _getButtonRow()));
  }

  Future _processImage(
      String filePath, EdgeDetectionResult edgeDetectionResult) async {
    if (!mounted || filePath == null) {
      return;
    }

    bool result =
        await EdgeDetector().processImage(filePath, edgeDetectionResult);

    if (result == false) {
      return;
    }

    setState(() {
      imageCache.clearLiveImages();
      imageCache.clear();
      croppedImagePath = imagePath!;
    });
  }

  Widget _getButtonRow() {
    if (imagePath != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              edgeDetectionResult = null;
              imagePath = null;
            });
          },
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: onTakePictureButtonPressed,
        child: const Icon(Icons.camera_alt),
      ),
    ]);
  }

  void onTakePictureButtonPressed() async {
    String? filePath = await takePicture();

    log('Picture saved to $filePath');

    await _detectEdges(filePath!);
  }

  void _onGalleryButtonPressed() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final filePath = pickedFile!.path;

    log('Picture saved to $filePath');

    _detectEdges(filePath);
  }

  Future _detectEdges(String filePath) async {
    if (!mounted || filePath == null) {
      return;
    }

    setState(() {
      imagePath = filePath;
    });

    EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);

    setState(() {
      edgeDetectionResult = result;
    });
  }
}
