import 'package:flutter/material.dart';
import 'views/onboarding_screen.dart';
import 'views/home_screen.dart';
import 'views/registration_screen.dart';
import 'views/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/signin': (context) => const SigninScreen(),
      },
    );
  }
}
