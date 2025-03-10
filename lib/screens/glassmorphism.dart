import 'dart:ui';
import 'package:flutter/material.dart';

class Glassmorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final double radius;
  final Widget child;

  const Glassmorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.radius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 211, 211, 211).withOpacity(opacity),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            border: Border.all(
              width: 1.6,
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
