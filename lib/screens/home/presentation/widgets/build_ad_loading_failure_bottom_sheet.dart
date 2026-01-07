import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildAdLoadingFailedBottomSheet(BuildContext context){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Try Again later!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        const Text(
          "There was a problem loading. Please try again in a few moments",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red
            ),
          ),
        ),
      ],
    ),
  );
}