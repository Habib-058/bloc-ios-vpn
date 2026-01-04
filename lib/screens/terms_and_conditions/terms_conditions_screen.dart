import 'package:bloc_vpn_ios/screens/terms_and_conditions/widgets/accept_button_section.dart';
import 'package:bloc_vpn_ios/screens/terms_and_conditions/widgets/tc_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../privacy_policy/widgets/title_section.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

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
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 55),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    TitleSection(textTheme: textTheme),
                    const SizedBox(height: 32),
                    // Body Text
                    DetailsSection(textTheme: textTheme),
                    SizedBox(height: 90),
                    AcceptButtonSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





