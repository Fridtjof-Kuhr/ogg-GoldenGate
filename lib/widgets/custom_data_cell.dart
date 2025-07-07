import 'package:flutter/material.dart';

class CustomDataCell extends StatelessWidget {
  final String text;
  const CustomDataCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFACD62),
          border: Border.all(color: const Color(0xFFAE562C), width: 1.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
