import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_assets.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(-8, 0), // move 5 pixels left
                child: Image.asset(
                  AppAssets.light.appLogo,
                  width: 90,
                  height: 90,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}