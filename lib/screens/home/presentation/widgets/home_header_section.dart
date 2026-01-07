import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: SvgPicture.asset(
            "assets/svg/menu.svg",
            width: 40,
            height: 40,
          ),
        ),
        SvgPicture.asset(
          "assets/svg/home_cap.svg",
          height: 58,
          width: 150,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}