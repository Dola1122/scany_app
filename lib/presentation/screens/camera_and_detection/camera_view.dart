import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  CameraView({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return _getCameraPreview(context);
  }

  Widget _getCameraPreview(context) {
    final size = MediaQuery.of(context).size.width;
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    return SizedBox(
      height: 4 * size / 3,
      width: size,
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
            alignment: Alignment.center,
            width: size,
            child: CameraPreview(controller), // this is my CameraPreview
          ),
        ),
      ),
    );
  }
}

// Center(
// child: AspectRatio(
// aspectRatio: 1/controller.value.aspectRatio,
// child: CameraPreview(controller)
// )
// );
