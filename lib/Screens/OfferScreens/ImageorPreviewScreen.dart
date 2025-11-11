import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageOrWithPreviewScreen extends StatefulWidget {
  final String imgUrl;
  final bool withInteractiveViewer;

  const ImageOrWithPreviewScreen(
      {super.key, required this.imgUrl, required this.withInteractiveViewer});

  @override
  State<ImageOrWithPreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImageOrWithPreviewScreen> {
  final transformationController = TransformationController();
  TapDownDetails doubleTapDetails = TapDownDetails();

  handleDoubleTap() {
    if (transformationController.value != Matrix4.identity()) {
      transformationController.value = Matrix4.identity();
    } else {
      final position = doubleTapDetails.localPosition;
      // For a 3x zoom
      transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.withInteractiveViewer
        ? Scaffold(
      body: Center(
          child: GestureDetector(
            onDoubleTapDown: (d) => doubleTapDetails = d,
            onDoubleTap: handleDoubleTap,
            child: InteractiveViewer(
              transformationController: transformationController,
              child: CachedNetworkImage(
                imageUrl: widget.imgUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          )),
    )
        : CachedNetworkImage(
      height: double.maxFinite,
      width: double.maxFinite,
      imageUrl: widget.imgUrl,
      fit: BoxFit.fill,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}