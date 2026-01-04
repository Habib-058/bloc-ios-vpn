import 'package:bloc_vpn_ios/screens/privacy_policy/widgets/logo_section.dart';
import 'package:bloc_vpn_ios/screens/privacy_policy/widgets/pp_content_section.dart';
import 'package:bloc_vpn_ios/screens/privacy_policy/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              LogoSection(),
              const SizedBox(height: 8),
              TitleSection(textTheme: textTheme),
              SizedBox(height: 22),
              // Scrollable privacy text
              PPContentSection(textTheme: textTheme),
            ],
          ),
        ),
      ),
    );
  }
}

