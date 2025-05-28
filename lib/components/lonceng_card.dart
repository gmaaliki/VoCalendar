import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoncengCard extends StatelessWidget {
  const LoncengCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Container(
        height: 300.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBDF152).withOpacity(0.8),
              blurRadius: 16.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Center(
          child: Lottie.asset(
            'assets/lotties/lonceng2.json',
            width: 300.h,
            height: 300.h,
          ),
        ),
      ),
    );
  }
}
