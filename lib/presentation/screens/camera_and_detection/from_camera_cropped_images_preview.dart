import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/from_camera_cubit/form_camera_cubit.dart';
import 'package:scany/constants/strings.dart';

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
                    BlocProvider.of<FromCameraCubit>(context).newPopBack(context);
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
                            .rotateImageModel(
                                BlocProvider.of<FromCameraCubit>(context).images[
                                    BlocProvider.of<FromCameraCubit>(context)
                                        .currentImageIndex],
                                -90);
                        BlocProvider.of<FromCameraCubit>(context)
                            .images[BlocProvider.of<FromCameraCubit>(context)
                                .currentImageIndex]
                            .edgeDetectionResult
                            ?.rotateDetectionResult(-90);
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
            body: Container(
              color: Colors.black87,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  height: double.infinity,
                  onPageChanged: (index, reason) {
                    BlocProvider.of<FromCameraCubit>(context).currentImageIndex =
                        index;
                  },
                  // viewportFraction: 0.9,
                  // aspectRatio: 2.0,
                  // initialPage: 2,
                ),
                itemCount: BlocProvider.of<FromCameraCubit>(context).images.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Center(
                    child: Image.file(
                      File(
                        BlocProvider.of<FromCameraCubit>(context)
                            .images[itemIndex]
                            .croppedImagePath!,
                      ),
                      fit: BoxFit.contain,
                      key: GlobalKey(),
                    ),
                  );
                },
              ),
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
