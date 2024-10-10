import 'package:flutter/material.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'views/onboarding_screen.dart';
import 'layout/main_page.dart';
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
        '/main': (context) => const MainPage(),
        '/registration': (context) => const RegistrationScreen(),
        '/signin': (context) => const SigninScreen(),
      },
    );
  }
}
