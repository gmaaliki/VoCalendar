import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousButton extends StatelessWidget {
  final PageController controller;

  const PreviousButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {
        controller.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      child: Text(
        'Back',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

    // return GestureDetector(
    //   onTap: () {
    //     controller.previousPage(
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.easeIn,
    //     );
    //   },
    //   child: const Text(
    //     'Back',
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 16,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );