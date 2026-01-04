

import 'package:bloc_vpn_ios/screens/terms_and_conditions/widgets/tc_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      tcTexts,
      style: textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          // height: 1.6,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          height: 1.8,
          fontFamily: "gilRoyRegular"
      ),
      textAlign: TextAlign.center,
    );
  }
}