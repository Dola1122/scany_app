import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/from_camera_cubit/form_camera_cubit.dart';
import 'package:scany/constants/strings.dart';
import 'package:scany/data/models/image_model.dart';
import 'package:scany/presentation/widgets/cropped_images_preview_widgets/custom_images_list_view.dart';

import 'image_view.dart';

class EditCapturedImagesScreen extends StatelessWidget {
  const EditCapturedImagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FromCameraCubit, FromCameraState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  onPressed: () async {
                    BlocProvider.of<FromCameraCubit>(context)
                        .newPopBack(context);
                  },
                  icon: Icon(Icons.check),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.black,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.rotate_left_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await BlocProvider.of<FromCameraCubit>(context)
                            .rotateImageModelWithIndex(-90);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.expand_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            body: CustomImagesListView(
              imageModels: BlocProvider.of<FromCameraCubit>(context).images,
              numberOfItems:
                  BlocProvider.of<FromCameraCubit>(context).images.length,
              onPageChanged: (index, reason) {
                BlocProvider.of<FromCameraCubit>(context).currentImageIndex =
                    index;
              },
            )
            // Container(
            //   color: Colors.black,
            //   child: Center(
            //     child: Image.file(
            //         File(BlocProvider.of<CameraCubit>(context).currentImage.croppedImagePath!),
            //         fit: BoxFit.contain),
            //   ),
            // ),
            );
      },
    );
  }
}
