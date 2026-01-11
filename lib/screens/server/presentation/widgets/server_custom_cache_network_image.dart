import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_assets.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  const CustomCacheNetworkImage(
      {super.key,
        required this.imageUrl,
        this.width,
        this.height,
        this.fit = BoxFit.cover,
        this.borderRadius,
        this.placeholder,
        this.errorWidget});

  @override
  Widget build(BuildContext context) {
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    final int? cacheWidth =
    width != null ? (width! * dpr).round() : null;
    final int? cacheHeight =
    height != null ? (height! * dpr).round() : null;

    return CachedNetworkImage(
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) =>
      placeholder ?? _FlagShimmer(),
      errorWidget: (_, __, ___) => errorWidget ??
          Image.asset(
            AppAssets.light.flag,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
    );


  }

}

class _FlagShimmer extends StatelessWidget {
  const _FlagShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: SizedBox(
        width: 28,
        height: 18,
      ),
    );
  }
}