import 'package:flutter/material.dart';

class StoryClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutoutRadius;
  final double containerRadius;

  const StoryClipper({
    required this.borderRadius,
    required this.cutoutRadius,
    required this.containerRadius,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, borderRadius * 2);
    path.arcToPoint(Offset(borderRadius * 2, 0.0),
        radius: Radius.circular(borderRadius * 2));
    path.lineTo((size.width * 0.5) - cutoutRadius, 0.0);

    path.arcToPoint(
      Offset((size.width * 0.5) + cutoutRadius, 0.0),
      clockwise: false,
      radius: Radius.circular(cutoutRadius),
    );

    path.lineTo(size.width - borderRadius * 2, 0.0);
    path.arcToPoint(Offset(size.width, borderRadius * 2),
        radius: Radius.circular(borderRadius * 2));
    path.lineTo(size.width, size.height - containerRadius);
    path.arcToPoint(Offset(size.width - containerRadius, size.height),
        radius: Radius.circular(containerRadius));

    path.lineTo(containerRadius, size.height);
    path.arcToPoint(Offset(0, size.height - containerRadius),
        radius: Radius.circular(containerRadius));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
