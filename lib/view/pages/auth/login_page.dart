import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/lonceng_card.dart';
import 'package:flutterapi/components/my_elevated_button.dart';
import 'package:flutterapi/components/square_tile.dart';
import 'package:flutterapi/helper/top_snackbar.dart';
import 'package:flutterapi/services/auth/auth_service.dart';
import 'package:flutterapi/view/pages/auth/forgot_password_page.dart';
import 'package:flutterapi/view/pages/auth/register_page.dart';
import 'package:flutterapi/view/pages/speech_to_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 0.02.sh),
                LoncengCard(),
                SizedBox(height: 10.h),
                Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.w,
                  ),
                ),
                Text(
                  'Login to your account!',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Scrollable login form
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, size: 24.r),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, size: 24.r),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFFBDF152),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Login Button
                      MyElevatedButton(
                        text: 'LOGIN',
                        textColor: Colors.black,
                        backgroundColor: const Color(0xFFBDF152),
                        onPressed: onLoginPressed,
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5.h,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          const Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Divider(
                              thickness: 0.5.h,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Social Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                            imagePath: 'assets/images/google.png',
                            onTap: () {
                              // Google Login
                            },
                          ),
                          SizedBox(width: 20.w),
                          SquareTile(
                            imagePath: 'assets/images/apple.png',
                            onTap: () {
                              // Apple Login
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Don't have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              ' Register here',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFFBDF152),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onLoginPressed() async {
    final authService = AuthService();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Email and password cannot be empty',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    if (!emailController.text.contains('@gmail.com')) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please enter a valid gmail address',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      showTopSnackbar(
        context: context,
        title: 'Login Success',
        message:
            'Welcome to VoCalendar, ${emailController.text.split('@')[0]}!',
        contentType: ContentType.success,
        shadowColor: Colors.green.shade300,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SpeechHomePage()),
      );
    } catch (e) {
      showTopSnackbar(
        context: context,
        title: 'Login Failed',
        message: 'Email or password is incorrect',
        contentType: ContentType.failure,
        shadowColor: Colors.red.shade300,
      );
    }
  }
}
