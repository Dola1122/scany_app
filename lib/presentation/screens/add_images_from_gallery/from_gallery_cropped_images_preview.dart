import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/from_gallery_cubit/from_gallery_cubit.dart';

class EditCapturedImagesScreen extends StatelessWidget {
  const EditCapturedImagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FromGalleryCubit(),
      child: BlocConsumer<FromGalleryCubit, FromGalleryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FromGalleryInitial) {
            BlocProvider.of<FromGalleryCubit>(context)
                .pickImagesFromGallery(context);
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                actions: [
                  IconButton(
                    onPressed: () async {
                      BlocProvider.of<FromGalleryCubit>(context)
                          .addSelectedImages(context);
                    },
                    icon: Icon(Icons.check),
                  ),
                ],
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () {
                      BlocProvider.of<FromGalleryCubit>(context)
                          .popBack(context);
                    }),
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
                          await BlocProvider.of<FromGalleryCubit>(context)
                              .rotateImageModel(
                                  BlocProvider.of<FromGalleryCubit>(context)
                                          .images[
                                      BlocProvider.of<FromGalleryCubit>(context)
                                          .currentImageIndex],
                                  -90);
                          BlocProvider.of<FromGalleryCubit>(context)
                              .images[BlocProvider.of<FromGalleryCubit>(context)
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
                      BlocProvider.of<FromGalleryCubit>(context)
                          .currentImageIndex = index;
                    },
                    // viewportFraction: 0.9,
                    // aspectRatio: 2.0,
                    // initialPage: 2,
                  ),
                  itemCount:
                      BlocProvider.of<FromGalleryCubit>(context).images.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return Center(
                      child: Image.file(
                        File(
                          BlocProvider.of<FromGalleryCubit>(context)
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
      ),
    );
  }
}
