import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';

import 'image_view.dart';

class EditPhotoScreen extends StatelessWidget {
  const EditPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                onPressed: () async {
                  BlocProvider.of<CameraCubit>(context).popBack(context);
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: Image.file(
                  File(BlocProvider.of<CameraCubit>(context).currentImage.croppedImagePath!),
                  fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
