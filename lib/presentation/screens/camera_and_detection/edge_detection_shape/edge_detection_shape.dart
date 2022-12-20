import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_edge_detection/edge_detection.dart';

import 'edge_painter.dart';
import 'magnifier.dart';
import 'touch_bubble.dart';

class EdgeDetectionShape extends StatefulWidget {
  EdgeDetectionShape({
    required this.renderedImageSize,
    required this.originalImageSize,
    required this.edgeDetectionResult,
  });

  final Size renderedImageSize;
  final Size originalImageSize;
  final EdgeDetectionResult edgeDetectionResult;

  @override
  _EdgeDetectionShapeState createState() => _EdgeDetectionShapeState();
}

class _EdgeDetectionShapeState extends State<EdgeDetectionShape> {
  double? edgeDraggerSize;

  EdgeDetectionResult? edgeDetectionResult;
  List<Offset>? points;

  double? renderedImageWidth;
  double? renderedImageHeight;
  double? top;
  double? left;

  Offset? currentDragPosition;

  @override
  void didChangeDependencies() {
    double shortestSide = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    edgeDraggerSize = shortestSide / 10;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    edgeDetectionResult = widget.edgeDetectionResult;
    _calculateDimensionValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("i am here \n ${currentDragPosition} \n i am here ");
    return Magnifier(
        visible: currentDragPosition != null,
        position: currentDragPosition ?? Offset(100,100),
        child: Stack(
          children: [
            _getTouchBubbles(),
            CustomPaint(
                painter: EdgePainter(
                    points: points!,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)))
          ],
        ));
  }

  void _calculateDimensionValues() {
    top = 0.0;
    left = 0.0;

    double widthFactor =
        widget.renderedImageSize.width / widget.originalImageSize.width;
    double heightFactor =
        widget.renderedImageSize.height / widget.originalImageSize.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = widget.originalImageSize.height * sizeFactor;
    top = ((widget.renderedImageSize.height - renderedImageHeight!) / 2);

    renderedImageWidth = widget.originalImageSize.width * sizeFactor;
    left = ((widget.renderedImageSize.width - renderedImageWidth!) / 2);
  }

  Offset _getNewPositionAfterDrag(
      Offset position, double renderedImageWidth, double renderedImageHeight) {
    return Offset(
        position.dx / renderedImageWidth, position.dy / renderedImageHeight);
  }

  Offset _clampOffset(Offset givenOffset) {
    double absoluteX = givenOffset.dx * renderedImageWidth!;
    double absoluteY = givenOffset.dy * renderedImageHeight!;

    return Offset(
        absoluteX.clamp(0.0, renderedImageWidth!) / renderedImageWidth!,
        absoluteY.clamp(0.0, renderedImageHeight!) / renderedImageHeight!);
  }

  Widget _getTouchBubbles() {
    points = [
      Offset(left! + edgeDetectionResult!.topLeft.dx! * renderedImageWidth!,
          top! + edgeDetectionResult!.topLeft.dy * renderedImageHeight!),
      Offset(left! + edgeDetectionResult!.topRight.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.topRight.dy * renderedImageHeight!),
      Offset(left! + edgeDetectionResult!.bottomRight.dx * renderedImageWidth!,
          top! + (edgeDetectionResult!.bottomRight.dy * renderedImageHeight!)),
      Offset(left! + edgeDetectionResult!.bottomLeft.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.bottomLeft.dy * renderedImageHeight!),
      Offset(left! + edgeDetectionResult!.topLeft.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.topLeft.dy * renderedImageHeight!),
    ];

    final Function onDragFinished = () {
      currentDragPosition = null;
      setState(() {});
    };

    return Container(
      width: widget.renderedImageSize.width,
      height: widget.renderedImageSize.height,
      child: Stack(
        children: [
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    setState(() {
                      currentDragPosition =
                          Offset(points![0].dx, points![0].dy);
                      Offset newTopLeft = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!);
                      edgeDetectionResult!.topLeft = _clampOffset(
                          edgeDetectionResult!.topLeft + newTopLeft);
                    });
                  },
                  onDragFinished: onDragFinished),
              left: points![0].dx - (edgeDraggerSize! / 2),
              top: points![0].dy - (edgeDraggerSize! / 2)),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    setState(() {
                      Offset newTopRight = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!);
                      edgeDetectionResult!.topRight = _clampOffset(
                          edgeDetectionResult!.topRight + newTopRight);
                      currentDragPosition =
                          Offset(points![1].dx, points![1].dy);
                    });
                  },
                  onDragFinished: onDragFinished),
              left: points![1].dx - (edgeDraggerSize! / 2),
              top: points![1].dy - (edgeDraggerSize! / 2)),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    setState(() {
                      Offset newBottomRight = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!);
                      edgeDetectionResult!.bottomRight = _clampOffset(
                          edgeDetectionResult!.bottomRight + newBottomRight);
                      currentDragPosition =
                          Offset(points![2].dx, points![2].dy);
                    });
                  },
                  onDragFinished: onDragFinished),
              left: points![2].dx - (edgeDraggerSize! / 2),
              top: points![2].dy - (edgeDraggerSize! / 2)),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    setState(() {
                      Offset newBottomLeft = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!);
                      edgeDetectionResult!.bottomLeft = _clampOffset(
                          edgeDetectionResult!.bottomLeft + newBottomLeft);
                      currentDragPosition =
                          Offset(points![3].dx, points![3].dy);
                    });
                  },
                  onDragFinished: onDragFinished),
              left: points![3].dx - (edgeDraggerSize! / 2),
              top: points![3].dy - (edgeDraggerSize! / 2)),
        ],
      ),
    );
  }
}

class Magnifier extends StatefulWidget {
  const Magnifier({
    required this.child,
    required this.position,
    this.visible = true,
    this.scale = 1.5,
    this.size = const Size(160, 160),
  }) : assert(child != null);

  final Widget child;
  final Offset position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  _MagnifierState createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  Size? _magnifierSize;
  double? _scale;
  Matrix4? _matrix;

  @override
  void initState() {
    _magnifierSize = widget.size;
    _scale = widget.scale;
    _calculateMatrix();

    super.initState();
  }

  @override
  void didUpdateWidget(Magnifier oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.visible && widget.position != null) _getMagnifier(context)
      ],
    );
  }

  void _calculateMatrix() {
    if (widget.position == null) {
      return;
    }

    setState(() {
      double newX = widget.position.dx - (_magnifierSize!.width / 2 / _scale!);
      double newY = widget.position.dy - (_magnifierSize!.height / 2 / _scale!);

      final Matrix4 updatedMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updatedMatrix;
    });
  }

  Widget _getMagnifier(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.matrix(_matrix!.storage),
            child: Container(
              width: _magnifierSize!.width,
              height: _magnifierSize!.height,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2)),
            ),
          ),
        ));
  }
}
