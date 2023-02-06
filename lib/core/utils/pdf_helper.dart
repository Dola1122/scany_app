import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class PdfHelper {

  static Future<void> addImageToPdf({required pw.Document pdf ,required Uint8List? imageJpg}) async {

    var decodedImage = await decodeImageFromList(imageJpg!);

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

    await OpenFilex.open(url);
  }
}
