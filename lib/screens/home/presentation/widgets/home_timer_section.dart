import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Connection Time see",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: "gilRoyRegular",
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "00:10:00",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 44,
            fontFamily: "gilRoyRegular",
          ),
        ),
        const SizedBox(height: 12),

        // Earn more time button (static)
        InkWell(
          onTap: () {},
          child: Container(
            width: 260,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 11, 10, 10),
                  Color(0xFF6622CC),
                  Color.fromARGB(255, 38, 210, 198),
                ],
                stops: [0.1, 0.0, 1.0],
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.more_time, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Tap to earn more time",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "gilRoyMedium",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}