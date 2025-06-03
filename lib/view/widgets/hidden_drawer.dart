// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutterapi/view/pages/home_page.dart';
// import 'package:flutterapi/view/pages/intro/intro_page.dart';
// import 'package:flutterapi/view/pages/setting_page.dart';
// import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

// class HiddenDrawer extends StatefulWidget {
//   const HiddenDrawer({super.key});

//   @override
//   State<HiddenDrawer> createState() => _HiddenDrawerState();
// }

// class _HiddenDrawerState extends State<HiddenDrawer> {
//   List<ScreenHiddenDrawer> pages = [];

//   final TextStyle myTextStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 18.sp,
//     fontWeight: FontWeight.bold,
//   );

//   @override
//   void initState() {
//     super.initState();

//     pages = [
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Home',
//           baseStyle: myTextStyle,
//           selectedStyle: myTextStyle.copyWith(color: Color(0xFFBDF152)),
//           colorLineSelected: Color(0xFFBDF152),
//         ),
//         const HomePage(),
//       ),
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Settings',
//           baseStyle: myTextStyle,
//           selectedStyle: myTextStyle.copyWith(color: Color(0xFFBDF152)),
//           colorLineSelected: Color(0xFFBDF152),
//         ),
//         const SettingPage(),
//       ),
//       // buatlah logout
//       ScreenHiddenDrawer(
//         ItemHiddenMenu(
//           name: 'Logout',
//           baseStyle: myTextStyle,
//           selectedStyle: myTextStyle.copyWith(color: Color(0xFFBDF152)),
//           colorLineSelected: Color(0xFFBDF152),
//         ),
//         GestureDetector(
//           onTap: () {
//             FirebaseAuth.instance.signOut().then((_) {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const IntroPage()),
//               );
//             });
//           },
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HiddenDrawerMenu(
//       backgroundColorMenu: Theme.of(context).colorScheme.surface,
//       backgroundColorAppBar: Color(0xFF3F24E6),
//       screens: pages,
//       initPositionSelected: 0,
//       slidePercent: 40,
//       contentCornerRadius: 25,
//       isTitleCentered: true,
//       verticalScalePercent: 80,
//     );
//   }
// }
