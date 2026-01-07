import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionButtonSection extends StatelessWidget {
  const ConnectionButtonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 14,
      shadowColor: Colors.black54,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: SizedBox(
          height: 140,
          width: 140,
          child: Image.asset(
            "assets/images/disconnected.png",
            width: 140,
            height: 140,
          ),
        ),
      ),
    );
  }
}