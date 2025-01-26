import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays a card with an optional icon and a title.
class SuggestionCard extends StatelessWidget {
  final String? icon;
  final String title;
  final String? color;

  const SuggestionCard({
    super.key,
    this.icon,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff5e5e5e),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensures Row takes minimum space
          children: [
            icon != null
                ? SvgPicture.asset(
                    "assets/images/$icon.svg",
                    color: Color(
                      int.parse(color!),
                    ),
                    height: 20,
                    width: 20,
                  )
                : Container(),
            SizedBox(
              width: 10, // Space between icon and text
            ),
            Text(
              title,
              style: TextStyle(
                color: Color(0xff5e5e5e),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
