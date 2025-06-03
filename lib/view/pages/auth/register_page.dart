import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/my_elevated_button.dart';
import 'package:flutterapi/helper/display_message.dart';
import 'package:flutterapi/helper/top_snackbar.dart';
import 'package:flutterapi/services/auth/auth_service.dart';
import 'package:flutterapi/view/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Header Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 0.45.sh,
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBDF152).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFBDF152).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      size: 40.r,
                      color: const Color(0xFFBDF152),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.w,
                    ),
                  ),
                  Text(
                    'Join us to get started',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Form Section
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
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

                      // Full Name Field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, size: 24.r),
                          hintText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFBDF152),
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, size: 24.r),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFBDF152),
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, size: 24.r),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFBDF152),
                              width: 2.w,
                            ),
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
                      SizedBox(height: 16.h),

                      // Confirm Password Field
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, size: 24.r),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFBDF152),
                              width: 2.w,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              ' Login here',
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

                      MyElevatedButton(
                        text: 'REGISTER',
                        textColor: Colors.black,
                        backgroundColor: const Color(0xFFBDF152),
                        onPressed: onRegisterPressed,
                      ),
                      const SizedBox(height: 20),
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

  void onRegisterPressed() async {
    final authService = AuthService();

    // empty all text field
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please fill all fields',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    if (!emailController.text.contains('@gmail.com')) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please enter a valid email address',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // pass and confirm pass not match
    if (passwordController.text != confirmPasswordController.text) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Password and Confirm Password do not match',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // pass and confirm pass match
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await authService.signUpWithEmailPassword(
          nameController.text,
          emailController.text,
          passwordController.text,
        );
        showTopSnackbar(
          context: context,
          title: 'Registration Successful',
          message: 'Please login to continue',
          contentType: ContentType.success,
          shadowColor: Colors.green.shade300,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        displayMessage(e.toString(), context);
        return;
      }
    }
  }
}
