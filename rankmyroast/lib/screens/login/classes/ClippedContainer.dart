import 'package:flutter/material.dart';

class ClippedContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1. Start at the Top-Left (lowered slightly to allow for an upward curve)
    path.moveTo(0, 50);

    // 2. TOP CURVE: Curve to the Top-Right
    // We stay between y=0 and y=50 so it stays visible
    path.cubicTo(
      size.width * 0.25,
      0, // Control 1
      size.width * 0.75,
      75, // Control 2
      size.width,
      50, // End Point (Top-Right)
    );

    // 3. RIGHT SIDE: Line down to the Bottom-Right
    path.lineTo(size.width, size.height - 50);

    // 4. BOTTOM CURVE: Curve back to the Bottom-Left
    // IMPORTANT: We draw from Right to Left now!
    path.cubicTo(
      size.width * 0.75,
      size.height, // Control 1 (near bottom-right)
      size.width * 0.25,
      size.height - 100, // Control 2 (near bottom-left)
      0,
      size.height - 50, // End Point (Bottom-Left)
    );

    // 5. CLOSE: Connects Bottom-Left back to Top-Left automatically
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
