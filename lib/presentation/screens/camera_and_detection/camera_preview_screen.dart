import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'camera_view.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({Key? key}) : super(key: key);

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CameraCubit>(context).initializeController();
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  // if (BlocProvider.of<CameraCubit>(context).croppedImagePath ==
                  //     null) {
                  //   await BlocProvider.of<CameraCubit>(context).processImage(
                  //       BlocProvider.of<CameraCubit>(context).imagePath!,
                  //       BlocProvider.of<CameraCubit>(context)
                  //           .edgeDetectionResult!);
                  //   Uint8List img = await File(
                  //           BlocProvider.of<CameraCubit>(context)
                  //               .croppedImagePath!)
                  //       .readAsBytes();
                  //   Navigator.pop(context, img);
                  // }
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              BlocProvider.of<CameraCubit>(context).controller == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : CameraView(
                      controller:
                          BlocProvider.of<CameraCubit>(context).controller!),
              Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              foregroundColor: Colors.white,
                              onPressed: () async {
                                String? filePath = await takePicture();

                                log('Picture saved to $filePath');

                                await _detectEdges(filePath!);
                                Navigator.of(context).pushNamed(edgeDetectionPreviewScreen);
                              },
                              child: const Icon(Icons.camera_alt),
                            ),
                          ]))),
            ],
          ),
        );
      },
    );
  }

  Future<String?> takePicture() async {
    if (!BlocProvider.of<CameraCubit>(context)
        .controller!
        .value
        .isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    String? filePath;

    if (BlocProvider.of<CameraCubit>(context)
        .controller!
        .value
        .isTakingPicture) {
      return null;
    }

    try {
      XFile image =
          await BlocProvider.of<CameraCubit>(context).controller!.takePicture();
      filePath = image.path;
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
    return filePath;
  }

  Future _detectEdges(String filePath) async {
    if (!mounted || filePath == null) {
      return;
    }

    setState(() {
      BlocProvider.of<CameraCubit>(context).imagePath = filePath;
    });

    EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);

    setState(() {
      BlocProvider.of<CameraCubit>(context).edgeDetectionResult = result;
    });
  }
}
