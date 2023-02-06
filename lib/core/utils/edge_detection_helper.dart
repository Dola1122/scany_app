import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';

class EdgeDetectionHelper {
  // detect edges for the image
  Future<EdgeDetectionResult?> detectEdges(String? imagePath) async {
    if (imagePath == null) {
      return null;
    }
    EdgeDetectionResult edgeDetectionResult =
        await EdgeDetector().detectEdges(imagePath!);
    return edgeDetectionResult;
  }

  // crop image
  Future<String?> cropDetectedImage({
    required String? imagePath,
    required EdgeDetectionResult? edgeDetectionResult,
  }) async {
    String croppedImagePath;
    if (imagePath == null) {
      return null;
    }
    final Directory extDir = await getTemporaryDirectory();
    croppedImagePath = '${extDir.path}/${DateTime.now()}.jpg';
    // await Directory(dirPath).create(recursive: true);
    log("process image function filepath1 ${imagePath}");
    log("process image function dirpath2 ${croppedImagePath}");
    await File(imagePath!).copy(croppedImagePath);
    bool result = await EdgeDetector()
        .processImage(croppedImagePath, edgeDetectionResult!);

    if (result == false) {
      return null;
    }

    imageCache.clearLiveImages();
    imageCache.clear();

    return croppedImagePath;
  }
}
