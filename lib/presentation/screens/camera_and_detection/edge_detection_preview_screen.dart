import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/constants/strings.dart';

import 'cropping preview.dart';

class EdgeDetectionPreviewScreen extends StatelessWidget {
  const EdgeDetectionPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.rotate_right_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {},
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
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await BlocProvider.of<CameraCubit>(context)
                          .addCurrentImage();
                    },
                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
            // actions: [
            //   IconButton(
            //     onPressed: () async {
            //       await BlocProvider.of<CameraCubit>(context).processImage();
            //       Navigator.of(context).pushNamed(editPhotoScreen);
            //     },
            //     icon: Icon(Icons.check),
            //   ),
            // ],
          ),
          body: Container(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ImagePreview(
                imagePath: BlocProvider.of<CameraCubit>(context)
                    .currentImage
                    .imagePath,
                edgeDetectionResult: BlocProvider.of<CameraCubit>(context)
                    .currentImage
                    .edgeDetectionResult,
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:simple_edge_detection/edge_detection.dart';
// import 'package:flutter/material.dart';
//
// import 'edge_painter.dart';
//
// class EdgeDetectionPreview extends StatefulWidget {
//   const EdgeDetectionPreview({super.key,
//     required this.imagePath,
//     required this.edgeDetectionResult
//   });
//
//   final String? imagePath;
//   final EdgeDetectionResult? edgeDetectionResult;
//
//   @override
//   _EdgeDetectionPreviewState createState() => _EdgeDetectionPreviewState();
// }
//
// class _EdgeDetectionPreviewState extends State<EdgeDetectionPreview> {
//   GlobalKey imageWidgetKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext mainContext) {
//     return Center(
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Center(
//               child: Text('Loading ...')
//           ),
//           Image.file(
//               File(widget.imagePath??""),
//               fit: BoxFit.contain,
//               key: imageWidgetKey
//           ),
//           FutureBuilder<ui.Image>(
//               future: loadUiImage(widget.imagePath??""),
//               builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
//                 return _getEdgePaint(snapshot, context);
//               }
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _getEdgePaint(AsyncSnapshot<ui.Image> imageSnapshot, BuildContext context) {
//     if (imageSnapshot.connectionState == ConnectionState.waiting)
//       return Container();
//
//     if (imageSnapshot.hasError)
//       return Text('Error: ${imageSnapshot.error}');
//
//     if (widget.edgeDetectionResult == null)
//       return Container();
//
//     final keyContext = imageWidgetKey.currentContext;
//
//     if (keyContext == null) {
//       return Container();
//     }
//
//     final box = keyContext.findRenderObject() as RenderBox;
//
//     return CustomPaint(
//         size: Size(box.size.width, box.size.height),
//         painter: EdgePainter(
//             topLeft: widget.edgeDetectionResult!.topLeft,
//             topRight: widget.edgeDetectionResult!.topRight,
//             bottomLeft: widget.edgeDetectionResult!.bottomLeft,
//             bottomRight: widget.edgeDetectionResult!.bottomRight,
//             image: imageSnapshot.data,
//             color: Theme.of(context).accentColor
//         )
//     );
//   }
//
//   Future<ui.Image> loadUiImage(String imageAssetPath) async {
//     final Uint8List data = await File(imageAssetPath).readAsBytes();
//     final Completer<ui.Image> completer = Completer();
//     ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
//       return completer.complete(image);
//     });
//     return completer.future;
//   }
// }
