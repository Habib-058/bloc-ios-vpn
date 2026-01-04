import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pp_content.dart';

class PPContentSection extends StatelessWidget {
  const PPContentSection({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: privacyTexts
              .map(
                (text) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                text,
                // textAlign: TextAlign,
                style: textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    // height: 1.6,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                    fontFamily: "gilRoyRegular"
                ),

              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}