import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildDrawerItem(
    {IconData? icon,
      String? imageAsset,
      required String title,
      required VoidCallback onTap,
      double? width,
      double? height}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      InkWell(
        onTap: onTap,
        child: Container(
          height: 38,
          // color: Colors.red,
          padding: EdgeInsets.only(bottom: 8 ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: 38,
                  height: 38 ,
                  child: imageAsset != null
                      ? Center(
                    child: Image.asset(imageAsset,
                        width: width, height: height),
                  )
                      : SizedBox(),
                ),
                SizedBox(
                  width: 12,
                ),
                Container(
                  // color: Colors.black,
                  child: Text(
                    textAlign: TextAlign.center,
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "gilRoyRegular",
                        fontWeight: FontWeight.w400,
                        height: 1.2
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 24 ,
      ),
    ],
  );

}