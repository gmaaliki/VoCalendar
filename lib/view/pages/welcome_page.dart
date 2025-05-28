import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/lonceng_card.dart';
import 'package:flutterapi/components/my_elevated_button.dart';
import 'package:flutterapi/components/my_outlined_button.dart';
import 'package:flutterapi/view/pages/auth/login_page.dart';
import 'package:flutterapi/view/pages/auth/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: 0.02.sh),
            const LoncengCard(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WELCOME TO',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 5.w,
                    ),
                  ),
                  Text(
                    'VOCALENDAR',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.w,
                      color: Color(0xFFBDF152),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 80.r,
                    color: Color(0xFFBDF152),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Voice-powered calendar assistant',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  Text(
                    'Plan your life by just speaking',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Buttons section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyOutlinedButton(
                          text: 'REGISTER',
                          textColor: Color(0xFFBDF152),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: MyElevatedButton(
                          text: 'LOGIN',
                          textColor: Colors.white,
                          backgroundColor: const Color(0xFF3F24E6),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
