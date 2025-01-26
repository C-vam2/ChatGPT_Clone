import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/imageProvider.dart';
import '../providers/suggestionProvider.dart';
import 'homeScreenBody.dart';
import 'imageWidget.dart';

/// A widget that displays an input message field with images and suggestions.
class InputMessageWidget extends StatelessWidget {
  const InputMessageWidget({
    super.key,
    required this.widget,
    required FocusNode focusNode,
    required TextEditingController textEditingController,
  })  : _focusNode = focusNode,
        _textEditingController = textEditingController;

  final HomeScreenBody widget;
  final FocusNode _focusNode;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Consumer2<SelectImageProvider, SuggestionProvider>(
        builder: (context, value2, value, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: widget.screenSize.width * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xff242424),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          // Change starts here
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value2.selectedImage.isNotEmpty && value2.isSent)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value2.selectedImage.length,
                  itemBuilder: (context, index) {
                    return ImageWidget(
                      imageModel: value2.selectedImage[index],
                      index: index,
                    );
                  },
                ),
              ),
            Flexible(
              child: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                keyboardType: TextInputType.text,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
