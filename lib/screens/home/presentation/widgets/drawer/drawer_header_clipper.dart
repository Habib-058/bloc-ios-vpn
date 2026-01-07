import 'package:flutter/cupertino.dart';

class DrawerHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.moveTo(0, 0);

    path.lineTo(0, size.height);


    path.quadraticBezierTo(
      size.width * 0.6,
      size.height,
      size.width,
      size.height * 0.7,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}