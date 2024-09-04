import 'package:flutter/material.dart';

class ClippedView extends CustomClipper<Path> {
  final double borderRadius;

  ClippedView({this.borderRadius = 0});

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height - 3;
    double heightOfTriangle = height - 10;
    double heightOfActualTriangle = heightOfTriangle - 10;
    double centreBefore = width / 2 - 12;
    double centreAfter = width / 2 + 12;

    final path = Path()
      ..lineTo(0, height)
      ..lineTo(centreBefore, heightOfTriangle)
      ..lineTo(width / 2, heightOfActualTriangle)
      ..lineTo(centreAfter, heightOfTriangle)
      ..lineTo(width, height)
      ..lineTo(width, 0)
      ..lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height - 3;
    double heightOfTriangle = height - 10;
    double heightOfActualTriangle = heightOfTriangle - 10;
    double centreBefore = width / 2 - 12;
    double centreAfter = width / 2 + 12;

    Path path = Path()
      ..lineTo(0, height)
      ..lineTo(centreBefore, heightOfTriangle)
      ..lineTo(width / 2, heightOfActualTriangle)
      ..lineTo(centreAfter, heightOfTriangle)
      ..lineTo(width, height)
      ..close();
    // here are my custom shapes

    canvas.drawShadow(path, Color(0X50000E79), 3.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
