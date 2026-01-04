

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Terms of Services",
      style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 24,
          color: Colors.black,
          fontFamily: "gilRoyRegular"
      ),
      textAlign: TextAlign.center,
    );
  }
}