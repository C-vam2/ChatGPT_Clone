import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/imageModel.dart';
import '../providers/imageProvider.dart';

/// A widget displaying an image with options for removal and loading/error state.
class ImageWidget extends StatefulWidget {
  final ImageModel imageModel;
  final int index;
  const ImageWidget({super.key, required this.imageModel, required this.index});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectImageProvider>(builder: (context, value, child) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget.imageModel.image.path),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // Centered Circular Progress Indicator
            value.selectedImage[widget.index].state == "loading"
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.0,
                    ),
                  )
                : value.selectedImage[widget.index].state == "error"
                    ? Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ))
                    : Container(),

            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  value.removeImage(widget.index);
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xff242424),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
