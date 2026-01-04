import 'package:bloc_vpn_ios/core/routes/app_routes.dart';
import 'package:bloc_vpn_ios/core/cache_repositories/user_preferences_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AcceptButtonSection extends StatelessWidget {
  const AcceptButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        UserPreferencesRepository.setAcceptedPolicy(true);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Container(
        width: 226,
        padding: EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C4B4), Color(0xFF5E6DDB)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "ACCEPT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: "gilRoyRegular",
            ),
          ),
        ),
      ),
    );
  }
}
