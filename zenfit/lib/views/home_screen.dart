import 'package:flutter/material.dart';
import 'package:zenfit/widgets/session_start_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String sessionTitle = "Renforcement cardio";
    int sessionDuration = 1;
    String sessionType = "AMRAP";

    return Scaffold(
      body: SessionStartScreen(
              title: sessionTitle,
              duration: sessionDuration,
              type: sessionType,
            ),
    );
  }
}
