import 'package:flutter/material.dart';

void displayMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'ALERT!',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 2),
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBDF152),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}
