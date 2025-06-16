import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/firebase_options.dart';
import 'package:flutterapi/providers/user_provider.dart';
import 'package:flutterapi/services/auth/auth_gate.dart';
import 'package:flutterapi/services/notifications/notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterapi/view/pages/ai-voice/schedule_page.dart';
import 'package:flutterapi/viewmodels/schedule_viewmodel.dart';
import 'package:provider/provider.dart';

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 100, 1, 249),
  brightness: Brightness.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initializeNotification();
  final currentUser = FirebaseAuth.instance.currentUser;
  final _userId = currentUser?.uid;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleViewModel(_userId)),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          colorScheme: kDarkColorScheme,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kDarkColorScheme.surface,
            foregroundColor: kDarkColorScheme.onSurface,
          ),
        ),
        home: AuthGate(),
      );
    },
  );
}
