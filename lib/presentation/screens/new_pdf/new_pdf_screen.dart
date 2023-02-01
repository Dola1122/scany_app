import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:scany/business_logic/new_pdf_cubit/new_pdf_cubit.dart';
import 'package:scany/data/models/detected_image_model.dart';
import 'package:scany/data/repository/edge_detection_helper.dart';
import 'package:scany/data/repository/pdf_helper.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scany/presentation/screens/add_images_from_gallery/from_gallery_cropped_images_preview.dart';
import '../../../constants/strings.dart';
import '../../../data/repository/images_helper.dart';
import '../../widgets/image_page.dart';
import '../camera_and_detection/camera_preview_screen.dart';

class NewPdfScreen extends StatefulWidget {
  const NewPdfScreen({Key? key}) : super(key: key);

  @override
  State<NewPdfScreen> createState() => _NewPdfScreenState();
}

class _NewPdfScreenState extends State<NewPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPdfCubit, NewPdfState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              type: ExpandableFabType.up,
              distance: 55,
              key: BlocProvider.of<NewPdfCubit>(context).key,
              children: [
                FloatingActionButton.small(
                  heroTag: "gallery",
                  child: const Icon(Icons.photo_library_outlined),
                  onPressed: () async {
                    List<DetectedImageModel>? images =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditCapturedImagesScreen()));
                    if (images != null) {
                      BlocProvider.of<NewPdfCubit>(context)
                          .detectedImages
                          .addAll(images);
                    }
                    BlocProvider.of<NewPdfCubit>(context).toggleFAB();

                    // Uint8List? imageJpg =
                    //     await ImagesHelper.getImageFromGallery();
                    //
                    // if (imageJpg != null) {
                    //   setState(() {
                    //     images.add(imageJpg);
                    //   });
                    // }
                    //
                    // BlocProvider.of<NewPdfCubit>(context).toggleFAB();
                  },
                ),
                FloatingActionButton.small(
                  heroTag: "camera",
                  child: const Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    ////Uint8List? imageJpg = await EdgeDetectionHelper().getImage();
                    // ImagesHelper.getImageFromCamera();

                    List<DetectedImageModel>? newImages =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CameraPreviewScreen(),
                      ),
                    );
                    if (newImages != null) {
                      BlocProvider.of<NewPdfCubit>(context)
                          .detectedImages
                          .addAll(newImages);
                    }
                    // setState(() {});
                    BlocProvider.of<NewPdfCubit>(context).toggleFAB();
                    // open and close FAB
                    // final state = _key.currentState;
                    // if (state != null) {
                    //   debugPrint('isOpen:${state.isOpen}');
                    //   state.toggle();
                    // }
                  },
                ),
              ],
            ),
            appBar: AppBar(
              title: TextField(
                controller:
                    BlocProvider.of<NewPdfCubit>(context).fileNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "file name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    BlocProvider.of<NewPdfCubit>(context).addAndSavePdf();
                    Future.delayed(
                      Duration(seconds: 2),
                      () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ],
            ),
            body: BlocProvider.of<NewPdfCubit>(context).detectedImages.isEmpty
                ? Center(
                    child: Text(
                      "No pages, Try add new pages",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: ReorderableGridView.builder(
                        padding: EdgeInsets.all(24),
                        itemCount: BlocProvider.of<NewPdfCubit>(context)
                            .detectedImages
                            .length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2 / 3,
                          crossAxisCount: 2,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 12,
                        ),
                        onReorder: BlocProvider.of<NewPdfCubit>(context)
                            .reorderTwoPages,
                        itemBuilder: (context, index) {
                          return InkWell(
                            key: Key("$index"),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  editDetectedImageScreen,
                                  arguments: index);
                            },
                            child: ImagePage(
                              imagePath: BlocProvider.of<NewPdfCubit>(context)
                                  .detectedImages[index]
                                  .croppedImagePath!,
                              index: index,
                            ),
                          );
                        }),
                  ));
      },
    );
  }
}
