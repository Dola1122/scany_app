import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/from_gallery_cubit/from_gallery_cubit.dart';
import 'package:scany/presentation/widgets/cropped_images_preview_widgets/custom_images_list_view.dart';
import 'from_gallery_edge_detection_preview_screen.dart';

class EditCapturedImagesScreen extends StatefulWidget {
  const EditCapturedImagesScreen({Key? key}) : super(key: key);

  @override
  State<EditCapturedImagesScreen> createState() =>
      _EditCapturedImagesScreenState();
}

class _EditCapturedImagesScreenState extends State<EditCapturedImagesScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FromGalleryCubit>(context).pickImagesFromGallery(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FromGalleryCubit, FromGalleryState>(
      builder: (context, state) {
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
                    BlocProvider.of<FromGalleryCubit>(context).popBack(context);
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
                            .rotateImageModelWithIndex(-90);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.expand_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EdgeDetectionPreviewScreen()));
                      },
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
              imageModels: BlocProvider.of<FromGalleryCubit>(context).images,
              numberOfItems:
                  BlocProvider.of<FromGalleryCubit>(context).images.length,
              onPageChanged: (index, reason) {
                BlocProvider.of<FromGalleryCubit>(context).currentImageIndex =
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
