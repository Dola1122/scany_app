import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';

class CameraView extends StatelessWidget {

  final CameraController controller;

  const CameraView({super.key, required this.controller});

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                  alignment: Alignment.center,
                  width: size,
                  child: CameraPreview(controller)),
            ),
            BlocProvider.of<CameraCubit>(context).focusTaped
                ? const Center(
              child: Icon(
                Icons.center_focus_strong_outlined,
                color: Colors.red,
                size: 50,
              ),
            )
                : const SizedBox(
              height: 0,
              width: 0,
            ),
          ],
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
