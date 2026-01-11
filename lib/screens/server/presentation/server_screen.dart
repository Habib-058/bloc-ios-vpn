import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';
import 'package:bloc_vpn_ios/screens/server/presentation/bloc/server_screen_bloc.dart';
import 'package:bloc_vpn_ios/screens/server/presentation/bloc/server_screen_event.dart';
import 'package:bloc_vpn_ios/screens/server/presentation/widgets/server_custom_cache_network_image.dart';
import 'package:bloc_vpn_ios/screens/server/presentation/widgets/server_server_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_assets.dart';
import '../../../core/utils/dependency_injection/core_dependencies.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../domain/entities/selected_server_entity.dart';

class ServerScreen extends StatelessWidget {
  const ServerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocProvider(
        create: (context) => getIt<ServerScreenBloc>()..add(const FetchServersEvent()),
        child: Scaffold(
          backgroundColor: const Color(0xFFEEF0F4),
          appBar: const CustomAppBar(),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  height: 54.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 5),
                    indicator: ShapeDecoration(
                      color: const Color(0xFF32C0EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    tabs: [
                      Tab(
                          child: Text(
                            "Free",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "gilRoyBold"),
                          )),
                      Tab(
                          child: Text("Premium",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "gilRoyBold"))),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                  const EdgeInsets.all(16),
                                  itemCount: 2,
                                  itemBuilder:
                                      (context, index) {
                                    return buildServerCard(
                                      'Test',
                                      "https://www.countryflags.io/us/flat/64.png",
                                      [],
                                      false,
                                      true,
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),

                      Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding:
                                  const EdgeInsets.all(16),
                                  itemCount: 2,
                                  itemBuilder:
                                      (context, index) {
                                    return buildServerCard(
                                      'Premium Test',
                                      AppAssets.light.flag,
                                      [],
                                      true,
                                      true,
                                    );
                                  },
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

