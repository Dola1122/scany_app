import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';
import 'package:scany/presentation/screens/camera_and_detection/edge_detector.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'camera_view.dart';

class CameraPreviewScreen extends StatelessWidget {
  const CameraPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CameraCubit>(context).initializeController();
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                BlocProvider.of<CameraCubit>(context).popBack(context);
              },
              icon: Icon(Icons.arrow_back_rounded),
            ),
            backgroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                BlocProvider.of<CameraCubit>(context).controller == null ||
                        BlocProvider.of<CameraCubit>(context)
                                .controller!
                                .value
                                .isInitialized ==
                            false
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraView(
                        controller:
                            BlocProvider.of<CameraCubit>(context).controller!),
                Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BlocProvider.of<CameraCubit>(context)
                                      .images
                                      .isNotEmpty
                                  ? CircleAvatar(
                                      child: Text(
                                          "${BlocProvider.of<CameraCubit>(context).images.length}"),
                                    )
                                  : Container(height: 1,),
                              FloatingActionButton(
                                foregroundColor: Colors.white,
                                onPressed: () async {
                                  await BlocProvider.of<CameraCubit>(context)
                                      .takePicture();

                                  log('Picture saved to ${BlocProvider.of<CameraCubit>(context).currentImage.imagePath}');

                                  await BlocProvider.of<CameraCubit>(context)
                                      .detectEdges();

                                  Navigator.of(context)
                                      .pushNamed(edgeDetectionPreviewScreen);
                                },
                                child: const Icon(Icons.camera_alt),
                                backgroundColor: Colors.black,
                              ),
                              BlocProvider.of<CameraCubit>(context)
                                      .images
                                      .isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        BlocProvider.of<CameraCubit>(context).newPopBack(context);
                                      }, icon: CircleAvatar(radius: 20,child: Icon(Icons.done)))
                                  : Container(height: 1,),
                            ]))),
              ],
            ),
          ),
        );
      },
    );
  }
}
