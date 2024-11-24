import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/onboarding_screen.dart';
import 'views/home_screen.dart';
import 'views/registration_screen.dart';
import 'views/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zenfit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user != null) {
              return const HomeScreen();
            }
            return const OnboardingScreen();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        '/registration': (context) => const RegistrationScreen(),
        '/signin': (context) => const SigninScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
