import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scany/data/repository/pdf_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/repository/images_helper.dart';
import '../widgets/image_page.dart';

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
                  await PdfHelper.addImageToPdf(pdf: pdf, imageJpg: imageJpg);
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
                Uint8List? imageJpg = await ImagesHelper.getImageFromCamera();

                if (imageJpg != null) {
                  //await PdfHelper.addImageToPdf(pdf: pdf, imageJpg: imageJpg);
                  images.add(imageJpg);
                  setState(() {});
                }

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
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final pdfFile = await PdfHelper.saveDocument(
                    name:
                        "${fileNameController.text != "" ? fileNameController.text : "example"}.pdf",
                    pdf: pdf);
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
        body: images == null
            ? Center(
                child: Text("no pages added"),
              )
            : Container(
                width: double.infinity,
                child: GridView.builder(
                    padding: EdgeInsets.all(24),
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      crossAxisCount: 2,
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return ImagePage(
                        image: images[index],
                        index: index,
                      );
                    }),
              ));
  }
}
