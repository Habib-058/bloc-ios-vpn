import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_assets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/widgets/build_flag_loader.dart';

Widget buildFlagImage(String flagPath) {
  // If it's a network URL
  if (flagPath.startsWith('http')) {
    // Check if it's an SVG
    if (flagPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        flagPath,
        width: 32,
        height: 25,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => buildFlagLoader(),
      );
    } else {
      // Regular image (PNG, JPG, etc.) with loading indicator
      return Image.network(
        flagPath,
        width: 32,
        height: 25,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return buildFlagLoader();
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppAssets.light.flag,
            width: 32,
            height: 25,
            fit: BoxFit.cover,
          );
        },
      );
    }
  } else {
    // Local asset
    return Image.asset(
      flagPath,
      width: 32,
      height: 25,
      fit: BoxFit.cover,
    );
  }
}