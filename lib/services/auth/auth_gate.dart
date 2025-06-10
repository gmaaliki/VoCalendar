import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/providers/user_provider.dart';
import 'package:flutterapi/view/pages/welcome_page.dart';
import 'package:flutterapi/view/widgets/navigation_menu.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              // Load user data by email or uid from Firestore
              Future.microtask(() {
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );
                userProvider.loadUserDataByEmail(user.email ?? '');
              });
              return const NavigationMenu();
            } else {
              return const WelcomePage();
            }
          }
          // loading indicator while checking auth state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
