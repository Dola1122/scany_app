import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scany/presentation/screens/camera_and_detection/edit_photo_screen.dart';
import 'package:scany/presentation/screens/home_screen.dart';
import 'package:scany/presentation/screens/new_pdf/new_pdf_screen.dart';
import 'constants/strings.dart';
import 'presentation/screens/camera_and_detection/camera_preview_screen.dart';
import 'presentation/screens/camera_and_detection/edge_detection_preview_screen.dart';

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
      case editPhotoScreen:
        return MaterialPageRoute(
          builder: (_) =>
              EditPhotoScreen(),
        );
      case cameraPreviewScreen:
        return MaterialPageRoute(
          builder: (_) =>
              CameraPreviewScreen(),
        );
      case edgeDetectionPreviewScreen:
        return MaterialPageRoute(
          builder: (_) =>
              EdgeDetectionPreviewScreen(),
        );
    }
  }
}
