import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/view/pages/home/home_page.dart';
import 'package:flutterapi/view/pages/profile/profile_page.dart';
import 'package:flutterapi/view/pages/event-manually/event_manually_page.dart';
import 'package:flutterapi/view/pages/ai-voice/voice_page.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    VoicePage(),
    EventManuallyPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: CrystalNavigationBar(
          currentIndex: _currentIndex,
          enablePaddingAnimation: true,
          indicatorColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.5),
          backgroundColor: const Color(0xFFBDF152),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          // borderWidth: 2,
          // outlineBorderColor: Colors.white,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.black,
              badge: Badge(
                label: Text("9+", style: TextStyle(color: Colors.black)),
              ),
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.voice,
              unselectedIcon: IconlyLight.voice,
              selectedColor: Colors.black,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.plus,
              unselectedIcon: IconlyLight.plus,
              selectedColor: Colors.black,
            ),

            /// Profile
            CrystalNavigationBarItem(
              icon: IconlyBold.profile,
              unselectedIcon: IconlyLight.profile,
              selectedColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
