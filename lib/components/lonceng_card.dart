import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoncengCard extends StatelessWidget {
  const LoncengCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBDF152).withOpacity(0.8),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/lonceng2.json',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
