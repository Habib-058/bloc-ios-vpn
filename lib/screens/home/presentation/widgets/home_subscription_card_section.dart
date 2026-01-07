import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionCardSection extends StatelessWidget {
  const SubscriptionCardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF28213D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Image.asset(
                "assets/images/diamond.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Unlock all features",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: "gilRoyBold",
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "No time limits",
                    style: TextStyle(
                      color: Color(0xFF3CAFEF),
                      fontSize: 16,
                      height: 1.2,
                      fontFamily: "gilRoyRegular",
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}