import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/business_logic/new_pdf_cubit/new_pdf_cubit.dart';
import 'package:scany/constants/strings.dart';

class EditDetectedImageScreen extends StatelessWidget {
  final int index;

  const EditDetectedImageScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPdfCubit, NewPdfState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
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
                        await BlocProvider.of<NewPdfCubit>(context)
                            .rotateImageModel(
                                BlocProvider.of<NewPdfCubit>(context)
                                    .detectedImages[index],
                                -90);
                        BlocProvider.of<NewPdfCubit>(context)
                            .detectedImages[index]
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
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Image.file(
                    File(BlocProvider.of<NewPdfCubit>(context)
                        .detectedImages[index]
                        .croppedImagePath!),
                    fit: BoxFit.contain,
                    key: GlobalKey(),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
