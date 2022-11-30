import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:scany/data/models/detected_image_model.dart';
import 'package:scany/data/repository/edge_detection_helper.dart';
import 'package:scany/data/repository/pdf_helper.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scany/presentation/screens/camera_and_detection/scan.dart';
import '../../constants/strings.dart';
import '../../data/repository/images_helper.dart';
import '../widgets/image_page.dart';
import 'camera_and_detection/camera_preview_screen.dart';

class NewPdfScreen extends StatefulWidget {
  const NewPdfScreen({Key? key}) : super(key: key);

  @override
  State<NewPdfScreen> createState() => _NewPdfScreenState();
}

class _NewPdfScreenState extends State<NewPdfScreen> {
  List<Uint8List> images = [];

  final _key = GlobalKey<ExpandableFabState>();
  pw.Document pdf = pw.Document();
  TextEditingController fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          distance: 55,
          key: _key,
          children: [
            FloatingActionButton.small(
              heroTag: "gallery",
              child: const Icon(Icons.photo_library_outlined),
              onPressed: () async {
                Uint8List? imageJpg = await ImagesHelper.getImageFromGallery();

                if (imageJpg != null) {
                  setState(() {
                    images.add(imageJpg);
                  });
                }

                final state = _key.currentState;
                if (state != null) {
                  debugPrint('isOpen:${state.isOpen}');
                  state.toggle();
                }
              },
            ),
            FloatingActionButton.small(
              heroTag: "camera",
              child: const Icon(Icons.camera_alt_outlined),
              onPressed: () async {
                ////Uint8List? imageJpg = await EdgeDetectionHelper().getImage();
                // ImagesHelper.getImageFromCamera();

                List<DetectedImageModel> detectedImages = [];
                List<DetectedImageModel>? newImages =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraPreviewScreen(),
                  ),
                );

                if (newImages != null) {
                  detectedImages.addAll(newImages);
                  for (int i = 0; i < newImages.length; i++) {
                    Uint8List img = await File(newImages[i].croppedImagePath!)
                        .readAsBytes();
                    images.add(img);
                  }
                }
                setState(() {});

                // open and close FAB
                final state = _key.currentState;
                if (state != null) {
                  debugPrint('isOpen:${state.isOpen}');
                  state.toggle();
                }
              },
            ),
          ],
        ),
        appBar: AppBar(
          title: TextField(
            controller: fileNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "file name",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                // add every image in the list as a page to the pdf
                for (int i = 0; i < images.length; i++) {
                  await PdfHelper.addImageToPdf(pdf: pdf, imageJpg: images[i]);
                }

                // save the pdf file
                final pdfFile = await PdfHelper.saveDocument(
                    name:
                        "${fileNameController.text != "" ? fileNameController.text : "example"}.pdf",
                    pdf: pdf);

                // open the pdf file
                await PdfHelper.openFile(pdfFile);

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
        body: images.isEmpty
            ? Center(
                child: Text("no pages added"),
              )
            : Container(
                width: double.infinity,
                child: ReorderableGridView.builder(
                    padding: EdgeInsets.all(24),
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      crossAxisCount: 2,
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 12,
                    ),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final element = images.removeAt(oldIndex);
                        images.insert(newIndex, element);
                      });
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        key: Key("$index"),
                        onTap: () {
                          Navigator.of(context).pushNamed(editPhotoScreen,
                              arguments: images[index]);
                        },
                        child: ImagePage(
                          image: images[index],
                          index: index,
                        ),
                      );
                    }),
              ));
  }
}
