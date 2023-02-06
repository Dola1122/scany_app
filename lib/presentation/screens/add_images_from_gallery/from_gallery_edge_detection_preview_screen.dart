import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/from_camera_cubit/form_camera_cubit.dart';
import 'package:scany/business_logic/from_gallery_cubit/from_gallery_cubit.dart';
import 'package:scany/constants/strings.dart';
import 'package:scany/presentation/screens/camera_and_detection/cropping%20preview.dart';

class EdgeDetectionPreviewScreen extends StatelessWidget {
  const EdgeDetectionPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FromGalleryCubit, FromGalleryState>(
      builder: (context, state) {
        return Scaffold(
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
                      await BlocProvider.of<FromGalleryCubit>(context)
                          .rotateImageModel(-90);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.rotate_right_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await BlocProvider.of<FromGalleryCubit>(context)
                          .rotateImageModel(90);
                    },
                  ),
                  BlocProvider.of<FromGalleryCubit>(context)
                          .images[BlocProvider.of<FromGalleryCubit>(context)
                              .currentImageIndex]
                          .autoDetection
                      ? IconButton(
                          icon: Icon(
                            Icons.expand_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            BlocProvider.of<FromGalleryCubit>(context)
                                .toggleDetection();
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.select_all,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            BlocProvider.of<FromGalleryCubit>(context)
                                .toggleDetection();
                          },
                        ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ImagePreview(
                imagePath: BlocProvider.of<FromGalleryCubit>(context)
                    .images[BlocProvider.of<FromGalleryCubit>(context)
                        .currentImageIndex]
                    .imagePath,
                edgeDetectionResult: BlocProvider.of<FromGalleryCubit>(context)
                    .images[BlocProvider.of<FromGalleryCubit>(context)
                        .currentImageIndex]
                    .edgeDetectionResult,
              ),
            ),
          ),
        );
      },
    );
  }
}
