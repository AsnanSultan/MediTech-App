import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  final Color bgColor;
  final String text;
  final String image;
  const MyBanner({required this.image, required this.bgColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      //  height: 300,

      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
      ),
    );
  }
}
