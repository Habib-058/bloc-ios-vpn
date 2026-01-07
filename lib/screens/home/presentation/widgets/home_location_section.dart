import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeLocationSection extends StatelessWidget {
  const HomeLocationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 37),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Choose location",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: "gilRoyRegular",
            ),
          ),
        ),
      ),
    );
  }
}