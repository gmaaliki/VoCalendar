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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top spacing
              SizedBox(height: 40.h),

              // Lottie animation (your existing component)
              Flexible(flex: 3, child: const LoncengCard()),

              SizedBox(height: 20.h),

              // App name - simplified
              Text(
                'VOCALENDAR',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFBDF152),
                  letterSpacing: 4.w,
                ),
              ),

              SizedBox(height: 12.h),

              // Subtitle - more concise
              Text(
                'Your AI-powered assistant for effortless scheduling',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color.fromARGB(255, 225, 225, 225),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Buttons section
              Column(
                children: [
                  MyElevatedButton(
                    text: 'REGISTER',
                    textColor: Colors.white,
                    backgroundColor: const Color(0xFF3F24E6),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 10.h),

                  MyOutlinedButton(
                    text: 'LOGIN',
                    textColor: const Color(0xFFBDF152),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
