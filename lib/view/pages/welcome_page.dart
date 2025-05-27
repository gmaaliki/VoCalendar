import 'package:flutter/material.dart';
import 'package:flutterapi/components/lonceng_card.dart';
import 'package:flutterapi/components/my_elevated_button.dart';
import 'package:flutterapi/components/my_outlined_button.dart';
import 'package:flutterapi/view/pages/login/login_page.dart';
import 'package:flutterapi/view/pages/register/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [Color(0xFF3F24E6), Color(0xFFBDF152)],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              // Section card
              const LoncengCard(),
              const SizedBox(height: 40),

              // Welcome Text
              const Text(
                'WELCOME TO',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),

              // Vocalendar
              const Text(
                'VOCALENDAR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xFFBDF152),
                ),
              ),
              const SizedBox(height: 16),

              // calendar icon
              const Icon(
                Icons.calendar_month_rounded,
                size: 100,
                color: Color(0xFFBDF152),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Voice-powered calendar assistant',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              // Subtitle Text
              Expanded(
                child: const Text(
                  'Plan your life by just speaking',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    // Register Button
                    Row(
                      children: [
                        Expanded(
                          child: MyOutlinedButton(
                            text: 'REGISTER',
                            textColor: Color(0xFFBDF152),
                            onPressed: () {
                              debugPrint('Register button pressed');
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
                    const SizedBox(height: 12),

                    // Login Button
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
                    const SizedBox(height: 14),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
