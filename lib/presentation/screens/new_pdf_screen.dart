import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scany/data/repository/pdf_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NewPdfScreen extends StatefulWidget {
  const NewPdfScreen({Key? key}) : super(key: key);

  @override
  State<NewPdfScreen> createState() => _NewPdfScreenState();
}

class _NewPdfScreenState extends State<NewPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Name"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {},
      ),
      body: Center(child: MaterialButton(
        onPressed: ()async{
          final pdfFile = await PdfHelper.addImageToPdf();

          await PdfHelper.openFile(pdfFile);
        },
        child: Text("new test pdf"),
      ),),
    );
  }
}
