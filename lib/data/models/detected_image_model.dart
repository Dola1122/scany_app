import 'dart:developer';
import 'dart:ui';

import 'package:scany/data/repository/edge_detection_helper.dart';
import 'package:simple_edge_detection/edge_detection.dart';

class DetectedImageModel {
  String? imagePath;
  String? croppedImagePath;
  EdgeDetectionResult? edgeDetectionResult;
  double? x;
  Offset? topLeft;
  Offset? topRight;
  Offset? bottomLeft;
  Offset? bottomRight;
  bool autoDetection = true;

  DetectedImageModel({
    this.imagePath,
    this.croppedImagePath,
    this.edgeDetectionResult,
  });

  // detect edges for the image
  Future<void> detectCurrentImageEdges() async {
    edgeDetectionResult = await EdgeDetectionHelper().detectEdges(imagePath);

    topLeft = Offset(
        edgeDetectionResult!.topLeft.dx, edgeDetectionResult!.topLeft.dy);
    topRight = Offset(
        edgeDetectionResult!.topRight.dx, edgeDetectionResult!.topRight.dy);
    bottomLeft = Offset(
        edgeDetectionResult!.bottomLeft.dx, edgeDetectionResult!.bottomLeft.dy);
    bottomRight = Offset(edgeDetectionResult!.bottomRight.dx,
        edgeDetectionResult!.bottomRight.dy);
  }

  // crop detected image
  Future<void> cropDetectedImage() async {
    croppedImagePath = await EdgeDetectionHelper().cropDetectedImage(
        edgeDetectionResult: edgeDetectionResult, imagePath: imagePath);
  }

  void toggleDetection() {
    EdgeDetectionResult? manual = EdgeDetectionResult(
        topLeft: const Offset(0.0, 0.0),
        topRight: const Offset(1.0, 0.0),
        bottomLeft: const Offset(0.0, 1.0),
        bottomRight: const Offset(1.0, 1.0));

    if (edgeDetectionResult!.topLeft == manual.topLeft &&
        edgeDetectionResult!.topRight == manual.topRight &&
        edgeDetectionResult!.bottomLeft == manual.bottomLeft &&
        edgeDetectionResult!.bottomRight == manual.bottomRight) {
      edgeDetectionResult = EdgeDetectionResult(
          topLeft: topLeft!,
          topRight: topRight!,
          bottomLeft: bottomLeft!,
          bottomRight: bottomRight!);
      autoDetection = true;
    } else {
      edgeDetectionResult = manual;
      autoDetection = false;
    }
  }
}
