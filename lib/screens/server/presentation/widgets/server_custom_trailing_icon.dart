import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_assets.dart';

Widget buildCustomTrailingIcon(bool isExpanded) {
  return AnimatedRotation(
    turns: isExpanded ? -0.25 : 0.0,
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    child: Image.asset(
      AppAssets.light.arrowDown,
      width: 21,
      height: 21,
      fit: BoxFit.contain,
    ),
  );
}