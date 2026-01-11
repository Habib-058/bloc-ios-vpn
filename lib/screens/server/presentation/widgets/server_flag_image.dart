import 'package:bloc_vpn_ios/screens/server/presentation/widgets/server_custom_cache_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/widgets/build_flag_loader.dart';

Widget buildFlagImage(String flagPath) {
  // If it's a network URL
  if (flagPath.startsWith('http')) {
    // Check if it's an SVG
    if (flagPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        flagPath,
        width: 48.w,
        height: 28.h,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => buildFlagLoader(),
      );
    } else {

      return  CustomCacheNetworkImage(imageUrl: flagPath, width: 48.w, height: 28.h,);
    }
  } else {
    // Local asset
    return Image.asset(
      flagPath,
      width: 48.w,
      height: 28.h,
      fit: BoxFit.cover,
    );
  }
}