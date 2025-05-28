import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/done_button.dart';
import 'package:flutterapi/components/next_button.dart';
import 'package:flutterapi/components/previous_button.dart';
import 'package:flutterapi/view/pages/intro/intro_1.dart';
import 'package:flutterapi/view/pages/intro/intro_2.dart';
import 'package:flutterapi/view/pages/intro/intro_3.dart';
import 'package:flutterapi/view/pages/welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2);
              });
            },
            children: const [Intro1(), Intro2(), Intro3()],
          ),

          // Skip Button (responsive position & font)
          Positioned(
            top: 70.h,
            right: 30.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Dot Indicator + Buttons
          Align(
            alignment: Alignment(0, 0.95),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // previous button
                  PreviousButton(controller: _controller),

                  // dot indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      spacing: 10.w,
                      activeDotColor: const Color(0xFFBDF152),
                      dotColor: Colors.grey,
                    ),
                  ),

                  // next or done button
                  isLastPage
                      ? const DoneButton()
                      : NextButton(controller: _controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
