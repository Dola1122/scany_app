import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:device_orientation/device_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'camera_view.dart';

class CameraPreviewScreen extends StatelessWidget {
  bool flashButtonIsPressed = false;

  CameraPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CameraCubit>(context).initializeController();
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                BlocProvider.of<CameraCubit>(context).popBack(context);
              },
              icon: Icon(Icons.arrow_back_rounded),
            ),
            backgroundColor: Colors.black,
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: Row(
                      children: [
                        Text(
                          "AUTO",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.flash_auto),
                      ],
                    ),
                  ),
                  // PopupMenuItem 2
                  PopupMenuItem(
                    value: 2,
                    // row with two children
                    child: Row(
                      children: [
                        Text(
                          "ON",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.flash_on),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    // row with two children
                    child: Row(
                      children: [
                        Text(
                          "OFF",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.flash_off),
                      ],
                    ),
                  ),
                ],
                offset: Offset(0, 60),
                color: Colors.black,
                elevation: 2,
                icon: BlocProvider.of<CameraCubit>(context).flashModeIcon(),
                // on selected we show the dialog box
                onSelected: (value) {
                  BlocProvider.of<CameraCubit>(context).changeFlashMode(value);
                },
              ),
              IconButton(
                  onPressed: () async {
                    for (int i = 0; i < 20; i++) {
                      await Future.delayed(const Duration(milliseconds: 1500));
                      deviceOrientation$.listen((orientation) {
                        print(orientation);
                      });
                    }
                  },
                  icon: Icon(Icons.crop_rotate_sharp))
            ],
          ),
          body: StreamBuilder(
            stream: deviceOrientation$,
            builder: (context, snapshot) {
                BlocProvider.of<CameraCubit>(context)
                  .detectCameraRotation(snapshot.data);
              return Container(
                color: Colors.black,
                child: Stack(
                  children: <Widget>[
                    BlocProvider.of<CameraCubit>(context).controller == null ||
                            BlocProvider.of<CameraCubit>(context)
                                    .controller!
                                    .value
                                    .isInitialized ==
                                false
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () async {
                              await BlocProvider.of<CameraCubit>(context)
                                  .focus();
                            },
                            child: CameraView(
                                controller:
                                    BlocProvider.of<CameraCubit>(context)
                                        .controller!),
                          ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  BlocProvider.of<CameraCubit>(context)
                                          .images
                                          .isNotEmpty
                                      ? RotatedBox(
                                          quarterTurns:
                                              BlocProvider.of<CameraCubit>(
                                                      context)
                                                  .cameraRotation,
                                          child: CircleAvatar(
                                            child: Text(
                                                "${BlocProvider.of<CameraCubit>(context).images.length}"),
                                          ),
                                        )
                                      : Container(
                                          height: 1,
                                        ),
                                  RotatedBox(
                                    quarterTurns:
                                        BlocProvider.of<CameraCubit>(context)
                                            .cameraRotation,
                                    child: FloatingActionButton(
                                      foregroundColor: Colors.white,
                                      onPressed: () async {
                                        await BlocProvider.of<CameraCubit>(
                                                context)
                                            .takePicture();

                                        log('Picture saved to ${BlocProvider.of<CameraCubit>(context).currentImage.imagePath}');

                                        await BlocProvider.of<CameraCubit>(
                                                context)
                                            .detectEdges();

                                        Navigator.of(context).pushNamed(
                                            edgeDetectionPreviewScreen);
                                      },
                                      child: const Icon(Icons.camera_alt),
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                  BlocProvider.of<CameraCubit>(context)
                                          .images
                                          .isNotEmpty
                                      ? RotatedBox(
                                          quarterTurns:
                                              BlocProvider.of<CameraCubit>(
                                                      context)
                                                  .cameraRotation,
                                          child: IconButton(
                                              onPressed: () {
                                                // BlocProvider.of<CameraCubit>(context).newPopBack(context);
                                                Navigator.of(context)
                                                    .pushNamed(editPhotoScreen);
                                              },
                                              icon: CircleAvatar(
                                                  radius: 20,
                                                  child: Icon(Icons.done))),
                                        )
                                      : Container(
                                          height: 1,
                                        ),
                                ]))),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
