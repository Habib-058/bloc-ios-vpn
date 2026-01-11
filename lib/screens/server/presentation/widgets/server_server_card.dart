import 'package:bloc_vpn_ios/screens/server/presentation/widgets/server_custom_trailing_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/presentation/widgets/home_flag_image.dart';
import '../../data/models/server_model.dart';
import '../../domain/entities/selected_server_entity.dart';

Widget buildServerCard(String country, String flagPath,
    List<ServerModel> servers, bool isPremium, bool isSubscribed) {
  bool isExpanded = false;
  return Container(
    // constraints: const BoxConstraints(minHeight: 66),
    margin: EdgeInsets.only(bottom: 10.sp),
    decoration: BoxDecoration(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15), // Shadow color with opacity
          offset: Offset(0, 3), // Horizontal and vertical offsets
          blurRadius: 2, // Blur effect
          spreadRadius: 0, // No spread effect (same as CSS)
        ),
      ],
    ),
    child: Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: StatefulBuilder(
        builder: (context, setState) {
          return ExpansionTile(
            trailing: buildCustomTrailingIcon(isExpanded),
            onExpansionChanged: (bool expanded) {
              setState(() {
                isExpanded = expanded;
              });
            },
            iconColor: const Color(0xFF00BFFF),
            collapsedIconColor: const Color(0xFF00BFFF),
            tilePadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
            childrenPadding:
            EdgeInsets.only(left: 22.sp, right: 22.sp, bottom: 12),
            leading: buildFlagImage(flagPath),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    // country,
                    country,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontFamily: "gilRoyMedium"),
                  ),
                ),
                Container(
                  height: 24.h,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isPremium
                          ? Color(0xFFC5B273)
                          : const Color(0xFF32C0EE),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isPremium
                          ? "Premium"
                          : "Free",
                      style: TextStyle(
                          color: isPremium
                              ? Color(0xFFC5B273)
                              : const Color(0xFF32C0EE),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          fontFamily: "gilRoyMedium"),
                    ),
                  ),
                ),
              ],
            ),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 1,
                    color: Colors.grey.shade200,
                    height: (servers.length * 32).toDouble(),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: servers
                          .asMap()
                          .entries
                          .map(
                            (entry) {
                          final index = entry.key;
                          final serverData = entry.value;
                          return InkWell(
                            onTap: () async {

                              final selectedServer = SelectedServer(
                                countryName: country,
                                server: serverData,
                                flagUrl: flagPath,
                              );

                              if(serverData.type == 'premium') {

                                return;
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    // serverData.name ?? '',
                                    "Server ${index + 1}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black87,
                                        fontFamily: "gilRoyMedium"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  const SizedBox(width: 8),
                  // Right vertical divider
                  Container(
                    width: 1,
                    color: Colors.grey.shade200,
                    height: (servers.length * 32).toDouble(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}