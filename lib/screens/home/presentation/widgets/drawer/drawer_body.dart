import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/app_assets.dart';
import 'build_drawer_item.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 25, left: 10),
        children: <Widget>[
          buildDrawerItem(
            imageAsset: AppAssets.light.home,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
            width: 25,
            height: 26,
          ),
          buildDrawerItem(
            imageAsset: AppAssets.light.privacy,
            title: "Privacy Policy",
            onTap: () {
              Navigator.pop(context);

            },
            width: 28,
            height: 30,
          ),
          buildDrawerItem(
            imageAsset: AppAssets.light.share,
            title: "Share To Friends",
            onTap: () {

              Navigator.pop(context);
              String appUrl =
                  'https://play.google.com/store/apps/details?id=com.capproject.capvpn&hl=en';
              String message =
                  'Let me recommend you this application: $appUrl';
              Share.share(message);
            },
            width: 26,
            height: 28,
          ),
          buildDrawerItem(
            imageAsset: AppAssets.light.email,
            title: "Contact Us",
            onTap: () {
              Navigator.pop(context);

            },
            width: 26,
            height: 28,
          ),
          buildDrawerItem(
            imageAsset: AppAssets.light.server,
            title: "Servers",
            onTap: () async {
              Navigator.pop(context);
            },
            width: 26,
            height: 26,
          ),
          buildDrawerItem(
            imageAsset: AppAssets.light.whiteDiamond,
            title: "Subscriptions",
            onTap: () {
              Navigator.pop(context);
            },
            width: 34,
            height: 32,
          ),
        ],
      ),
    );
  }
}