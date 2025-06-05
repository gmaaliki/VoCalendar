import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/account_info_row.dart';
import 'package:flutterapi/components/main_button.dart';
import 'package:flutterapi/components/my_alert_dialog.dart';
import 'package:flutterapi/providers/user_provider.dart';
import 'package:flutterapi/services/auth/auth_service.dart';
import 'package:flutterapi/view/pages/profile/edit_profile_page.dart';
import 'package:flutterapi/view/pages/welcome_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [const Color(0xFFBDF152), const Color(0xFF3F24E6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0.w,
                right: 20.0.w,
                top: 60.0.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    // backgroundImage: const AssetImage(
                    //   'assets/images/apple.png',
                    // ),
                    child: Icon(Icons.person, size: 40.sp, color: Colors.black),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        userData['email'] ?? 'No Email',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0.w),
              child: Container(
                padding: EdgeInsets.all(20.0.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // account details
                    Text(
                      'Account Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBDF152),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // name
                    AccountInfoRow(
                      icon: Icons.person,
                      title: 'Name',
                      value: userData['name'] ?? 'No Name',
                    ),
                    AccountInfoRow(
                      icon: Icons.email,
                      title: 'Email',
                      value: userData['email'] ?? 'No Email',
                    ),
                    AccountInfoRow(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: userData['phone'] ?? '-',
                    ),
                    AccountInfoRow(
                      icon: Icons.work,
                      title: 'Job',
                      value: userData['job'] ?? '-',
                    ),
                    SizedBox(height: 20.h),

                    const Spacer(),

                    // Button Edit
                    MainButton(
                      text: 'Edit Profile',
                      textColor: Colors.black,
                      icon: Icons.edit,
                      iconColor: Colors.black,
                      backgroundColor: const Color(0xFFBDF152),
                      shadowColor: const Color(0xFFBDF152),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8.h),

                    // Button Logout
                    MainButton(
                      text: 'Logout',
                      textColor: Colors.white,
                      icon: Icons.logout,
                      iconColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      shadowColor: Colors.redAccent,
                      onPressed: onLogoutPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
          title: 'Logout',
          titleColor: Colors.redAccent,
          iconTitle: Icons.logout,
          iconColor: Colors.redAccent,
          description: 'Are you sure you want to logout?',
          buttonText1: 'Cancel',
          buttonText2: 'Logout',
          backgroundColor: Colors.redAccent,
          onPressed: () {
            AuthService().signOut().then((value) {
              Provider.of<UserProvider>(context, listen: false).clearUserData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
                (route) => false,
              );
            });
          },
        );
      },
    );
  }
}
