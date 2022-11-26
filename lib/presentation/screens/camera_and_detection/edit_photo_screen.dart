import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';

import 'image_view.dart';

class EditPhotoScreen extends StatefulWidget {
  const EditPhotoScreen({super.key});

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  // if (croppedImagePath == null) {
                  //   await _processImage(imagePath!, edgeDetectionResult!);
                  //   Uint8List img = await File(croppedImagePath!).readAsBytes();
                  //   Navigator.pop(context, img);
                  // }

                  BlocProvider.of<CameraCubit>(context).popBack(context);


                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              ImageView(
                  imagePath:
                      BlocProvider.of<CameraCubit>(context).croppedImagePath!),
            ],
          ),
        );
      },
    );
  }
}

