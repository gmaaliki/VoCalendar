import 'package:flutter/material.dart';
import 'package:flutterapi/components/done_button.dart';
import 'package:flutterapi/components/next_button.dart';
import 'package:flutterapi/components/previous_button.dart';
import 'package:flutterapi/view/pages/intro/intro_1.dart';
import 'package:flutterapi/view/pages/intro/intro_2.dart';
import 'package:flutterapi/view/pages/intro/intro_3.dart';
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
            children: const [
              // Intro pages
              Intro1(),
              Intro2(),
              Intro3(),
            ],
          ),

          Positioned(
            top: 70,
            right: 40,
            child: GestureDetector(
              onTap: () {
                _controller.jumpToPage(2);
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //dot indicator
          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // previous button
                PreviousButton(controller: _controller),
                // dot indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(),
                ),

                // next button
                isLastPage
                    ? const DoneButton()
                    : NextButton(controller: _controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
