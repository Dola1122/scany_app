import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scany/presentation/screens/camera_and_detection/edit_captured_image_screen.dart';
import 'package:scany/presentation/screens/home/home_screen.dart';
import 'package:scany/presentation/screens/new_pdf/new_pdf_screen.dart';
import 'constants/strings.dart';
import 'presentation/screens/camera_and_detection/camera_preview_screen.dart';
import 'presentation/screens/camera_and_detection/edge_detection_preview_screen.dart';
import 'presentation/screens/new_pdf/edit_detected_image_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );

      case newPdfScreen:
        return MaterialPageRoute(
          builder: (_) => NewPdfScreen(),
        );
      case editCapturedImageScreen:
        return MaterialPageRoute(
          builder: (_) => EditCapturedImageScreen(),
        );
      case cameraPreviewScreen:
        return MaterialPageRoute(
          builder: (_) => CameraPreviewScreen(),
        );
      case edgeDetectionPreviewScreen:
        return MaterialPageRoute(
          builder: (_) => EdgeDetectionPreviewScreen(),
        );
      case editDetectedImageScreen:
        return MaterialPageRoute(
          builder: (_) => EditDetectedImageScreen(
            index: settings.arguments as int,
          ),
        );
    }
  }
}
