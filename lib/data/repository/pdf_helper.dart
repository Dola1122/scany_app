import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:scany/data/repository/images_helper.dart';

class PdfHelper {
  // static Future<File> generateCenteredText(String text) async {
  //   final pw.Document pdf = pw.Document();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) => pw.Center(
  //         child: pw.Text(text),
  //       ),
  //     ),
  //   );
  //
  //   return saveDocument(name: "my_example.pdf", pdf: pdf);
  // }


  static Future<void> addImageToPdf({required pw.Document pdf ,required Uint8List? imageJpg}) async {

    var decodedImage = await decodeImageFromList(imageJpg!);

    // File image = new File('image.png'); // Or any other way to get a File instance.
    // var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    // print(decodedImage.width);
    // print(decodedImage.height);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          29.7 * (decodedImage.width / decodedImage.height) * PdfPageFormat.cm,
          29.7 * PdfPageFormat.cm,
        ),
        build: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Image(pw.MemoryImage(imageJpg!), fit: pw.BoxFit.cover),
        ),
      ),
    );
  }

  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
