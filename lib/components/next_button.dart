import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextButton extends StatelessWidget {
  final PageController controller;

  const NextButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFBDF152),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Rounded corners
        ),
      ),
      onPressed: () {
        controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      child: Text(
        'Next',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

    // return GestureDetector(
    //   onTap: () {
    //     controller.nextPage(
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.easeIn,
    //     );
    //   },
    //   child: const Text(
    //     'Next',
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 16,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );