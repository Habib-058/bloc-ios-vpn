import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/theme/app_assets.dart';
import 'drawer_header_clipper.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required this.logoContainerHeight,
    required this.drawerWidth,
  });

  final double logoContainerHeight;
  final double drawerWidth;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DrawerHeaderClipper(), // Our custom clipper
      child: Container(
        height: logoContainerHeight,
        width: drawerWidth,
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                right: (drawerWidth * .3),
                bottom: (logoContainerHeight * .2 )),
            child: SvgPicture.asset(
              AppAssets.light.capSvg,
              width: 147,
              height: 169,
            ),
          ),
        ),
      ),
    );
  }
}