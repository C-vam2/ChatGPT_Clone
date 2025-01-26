import 'package:flutter/material.dart';

/// A widget that displays an animated splash loader with a fade-in and fade-out effect.
class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader>
    with SingleTickerProviderStateMixin {
  late Animation<double> _opacity;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController with the correct duration and reverse option
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..repeat(reverse: true); // Repeat animation with reverse effect

    // Create the fade animation with opacity change
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Static white circle
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: Color(0xffa2d2ff),
          ),
        ),
        // Animated red circle with opacity effect
        FadeTransition(
          opacity: _opacity,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: Color(0xfffdc5f5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when done
    super.dispose();
  }
}
