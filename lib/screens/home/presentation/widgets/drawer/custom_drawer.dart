import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drawer_body.dart';
import 'drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.75;
    final double logoContainerHeight = 320;
    return Drawer(
      width: drawerWidth,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // stops: [0.0, 0.75], // Purple dominates 75% from the top
            colors: [
              Color(0xFF6622CC),
              // Color(0xFF9d66ef), // Purple - dominant portion at top
              Color(0xFF22CCC2), // Cyan - bottom portion
            ],
          ),
        ),
        child: Column(
          children: [
            CustomDrawerHeader(logoContainerHeight: logoContainerHeight, drawerWidth: drawerWidth),
            DrawerBody(),
          ],
        ),
      ),
    );
  }


}






