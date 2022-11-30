import 'package:simple_edge_detection/edge_detection.dart';

class DetectedImageModel {
  String? imagePath;
  String? croppedImagePath;
  EdgeDetectionResult? edgeDetectionResult;

  DetectedImageModel({
     this.imagePath,
     this.croppedImagePath,
     this.edgeDetectionResult,
  });
}
