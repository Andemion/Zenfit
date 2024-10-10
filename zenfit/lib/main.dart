import 'package:flutter/material.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'views/onboarding_screen.dart';
import 'layout/main_page.dart';

void main() {
  runApp(MyApp());
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
      },
    );
  }
}
