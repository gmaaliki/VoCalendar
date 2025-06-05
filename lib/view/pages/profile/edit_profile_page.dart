import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapi/components/main_button.dart';
import 'package:flutterapi/components/row_button.dart';
import 'package:flutterapi/helper/top_snackbar.dart';
import 'package:flutterapi/providers/user_provider.dart';
import 'package:flutterapi/services/auth/auth_service.dart';
import 'package:flutterapi/services/database/firestore.dart';
import 'package:flutterapi/view/pages/welcome_page.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController jobController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers di initState
    final userData = Provider.of<UserProvider>(context, listen: false).userData;
    nameController = TextEditingController(text: userData['name'] ?? '-');
    emailController = TextEditingController(text: userData['email'] ?? '-');
    phoneController = TextEditingController(text: userData['phone'] ?? '-');
    jobController = TextEditingController(text: userData['job'] ?? '-');
  }

  @override
  void dispose() {
    // Jangan lupa dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).userData;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140.h,
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
            child: SingleChildScrollView(
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
                      Text(
                        'Account Details',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFBDF152),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Name field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Email field
                      TextField(
                        enabled: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: userData['email'] ?? 'No Email',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Phone field
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: userData['phone'] ?? 'No Phone',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Job field
                      TextField(
                        controller: jobController,
                        decoration: InputDecoration(
                          labelText: 'Job',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: userData['job'] ?? 'No Job',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // back & edit button
                      RowButton(
                        text1: 'Back',
                        text2: 'Save Changes',
                        onPressed: onSaveChangesPressed,
                      ),
                      const SizedBox(height: 10),

                      // delete account button
                      MainButton(
                        text: 'Delete Account',
                        textColor: Colors.white,
                        icon: Icons.delete,
                        iconColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        shadowColor: Colors.redAccent,
                        onPressed:
                            () => onDeleteAccountPressed(
                              context,
                              userData['email'] ?? '',
                            ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSaveChangesPressed() {
    final FirestoreService db = FirestoreService();
    final userData = Provider.of<UserProvider>(context, listen: false).userData;

    // Validate input fields
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        jobController.text.isEmpty) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Please fill in all fields',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // phone number validation
    if (phoneController.text.length < 10 || phoneController.text.length > 15) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'Phone number must be between 10 and 15 digits',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // no changes detected
    if (nameController.text == userData['name'] &&
        emailController.text == userData['email'] &&
        phoneController.text == userData['phone'] &&
        jobController.text == userData['job']) {
      showTopSnackbar(
        context: context,
        title: 'Alert',
        message: 'No changes detected',
        contentType: ContentType.warning,
        shadowColor: Colors.orange.shade300,
      );
      return;
    }

    // Prepare data to update
    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'job': jobController.text,
      'photoUrl': userData['photoUrl'] ?? '',
    };

    // Update user data in Firestore
    db.updateUserData(
      userData['email'] ?? '',
      updatedData['name'],
      updatedData['phone'],
      updatedData['job'],
      updatedData['photoUrl'],
    );

    // Update user data in UserProvider
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).updateUserData(userData['email'] ?? '', updatedData);
    // top snackbar
    showTopSnackbar(
      context: context,
      title: 'Success',
      message: 'Profile updated successfully',
      contentType: ContentType.success,
      shadowColor: Colors.green.shade300,
    );

    Navigator.pop(context);
  }

  void onDeleteAccountPressed(BuildContext context, String email) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10.w),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please confirm your password to delete this account permanently.',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () async {
                if (passwordController.text.isEmpty) {
                  showTopSnackbar(
                    context: context,
                    title: 'Alert',
                    message: 'Please enter your password',
                    contentType: ContentType.warning,
                    shadowColor: Colors.orange.shade300,
                  );
                  return;
                }

                try {
                  await AuthService().reauthenticateUser(
                    email,
                    passwordController.text,
                  );
                  await AuthService().deleteAccount();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                } catch (e) {
                  showTopSnackbar(
                    context: context,
                    title: 'Delete Account Failed',
                    message: 'Password is incorrect',
                    contentType: ContentType.failure,
                    shadowColor: Colors.red.shade300,
                  );
                  return;
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
