import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/view/pages/intro/intro_page.dart';
import 'package:flutterapi/view/pages/speech_to_text.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const SpeechHomePage();
          }
          // user is not logged in
          else {
            return const IntroPage();
          }
        },
      ),
    );
  }
}
