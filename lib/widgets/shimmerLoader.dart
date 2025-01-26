import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a shimmer loading effect with placeholders.
class ShimmerLoader extends StatelessWidget {
  final Size screenSize;
  const ShimmerLoader({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.height * 0.5, // Adjust height relative to screen size
      width: screenSize.width * 0.8, // Adjust width relative to screen size
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
              child: Container(
                height: screenSize.height *
                    0.023, // Adjust height relative to screen size
                width: screenSize.width *
                    0.25, // Adjust width relative to screen size
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            ...List.generate(5, (index) => _buildPlaceholder())
          ],
        ),
      ),
    );
  }

  /// Builds a placeholder with a specific height and width for the shimmer effect.
  Widget _buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Container(
        height:
            screenSize.height * 0.025, // Adjust height relative to screen size
        width: screenSize.width * 0.6, // Adjust width relative to screen size
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
