import 'package:flutter/material.dart';

/// The red TUFU wordmark.
class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 34});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/wordmark-transparent.png',
      height: height,
      fit: BoxFit.contain,
      semanticLabel: 'Tufu Movie',
    );
  }
}
