import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const MyElevatedButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    re,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: backgroundColor,
        shadowColor: backgroundColor.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
