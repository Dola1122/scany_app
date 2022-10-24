import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scany/presentation/screens/edit_photo_screen.dart';
import 'package:scany/presentation/screens/home_screen.dart';
import 'package:scany/presentation/screens/new_pdf_screen.dart';
import 'constants/strings.dart';

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
              EditPhotoScreen(image: settings.arguments as Uint8List),
        );
    }
  }
}
