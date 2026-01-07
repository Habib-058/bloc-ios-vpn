import 'package:bloc_vpn_ios/screens/home/presentation/widgets/drawer/custom_drawer.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_background.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_connection_button_section.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_header_section.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_location_section.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_subscription_card_section.dart';
import 'package:bloc_vpn_ios/screens/home/presentation/widgets/home_timer_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // Background image (static)
          HomeBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  HomeHeaderSection(scaffoldKey: scaffoldKey),

                  const Spacer(),

                  TimerSection(),

                  const SizedBox(height: 15),

                  SubscriptionCardSection(),

                  const SizedBox(height: 30),

                  ConnectionButtonSection(),

                  const SizedBox(height: 30),

                  HomeLocationSection(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),

          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
