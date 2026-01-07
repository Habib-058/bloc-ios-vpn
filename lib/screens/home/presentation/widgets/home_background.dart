import 'package:flutter/cupertino.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/map.png",
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }
}