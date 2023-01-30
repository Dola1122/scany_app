import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:meta/meta.dart';
import 'package:scany/data/models/detected_image_model.dart';
import 'package:scany/data/repository/images_helper.dart';
import 'package:scany/data/repository/pdf_helper.dart';

part 'new_pdf_state.dart';

class NewPdfCubit extends Cubit<NewPdfState> {
  NewPdfCubit() : super(NewPdfInitial());

  List<Uint8List> images = [];
  List<DetectedImageModel> detectedImages = [];
  final key = GlobalKey<ExpandableFabState>();
  pw.Document pdf = pw.Document();
  TextEditingController fileNameController = TextEditingController();

  // open and close FAB
  void toggleFAB() {
    final state = key.currentState;
    if (state != null) {
      debugPrint('isOpen:${state.isOpen}');
      state.toggle();
    }
    emit(NewPdfToggleFABState());
  }

  void addAndSavePdf() async {
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
  }

  void reorderTwoPages(int oldIndex, int newIndex) {
    final element = detectedImages.removeAt(oldIndex);
    detectedImages.insert(newIndex, element);
    emit(NewPdfReorderPagesState());
  }

  // rotate image model
  Future<void> rotateImageModel(DetectedImageModel image, angle) async {
    if (image.imagePath != null) {
      await ImagesHelper.rotateImage(image.imagePath ?? "", angle);
    }
    if (image.croppedImagePath != null) {
      await ImagesHelper.rotateImage(image.croppedImagePath ?? "", angle);
    }
    emit(NewPdfImageModelRotatedState());
  }
}
