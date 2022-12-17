import 'package:scany/data/repository/edge_detection_helper.dart';
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

  // detect edges for the image
  Future<void> detectCurrentImageEdges() async {
    edgeDetectionResult = await EdgeDetectionHelper().detectEdges(imagePath);
  }

  // crop detected image
  Future<void> cropDetectedImage() async {
    croppedImagePath = await EdgeDetectionHelper().cropDetectedImage(
        edgeDetectionResult: edgeDetectionResult, imagePath: imagePath);
  }
}
