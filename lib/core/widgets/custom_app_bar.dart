import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final EdgeInsetsGeometry? backIconPadding;

  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.backIconPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: centerTitle,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,  // Black icons on iOS
        statusBarIconBrightness: Brightness.dark, // Black icons on Android
      ),
      leading: Padding(
        padding: backIconPadding ?? const EdgeInsets.only(left: 16),
        child: SizedBox(
          height: 32,
          width: 32,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
            icon: SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                AppAssets.light.back,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      title: title != null
          ? Text(
        title!,
        style:  TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "gilRoy"
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}