import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const MyOutlinedButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: textColor),
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
