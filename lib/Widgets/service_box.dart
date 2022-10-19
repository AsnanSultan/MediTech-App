import 'package:flutter/material.dart';

class ServiceBox extends StatelessWidget {
  final String image;
  final String text;
  const ServiceBox({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 6),
        alignment: Alignment.bottomCenter,
        width: 107,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
