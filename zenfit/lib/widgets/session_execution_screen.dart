import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zenfit/widgets/session_end_screen.dart';

class SessionExecutionScreen extends StatefulWidget {
  final String title;
  final int duration;
  final String type;

  const SessionExecutionScreen({
    Key? key,
    required this.title,
    required this.duration,
    required this.type,
  }) : super(key: key);

  @override
  _SessionExecutionScreenState createState() => _SessionExecutionScreenState();
}

class _SessionExecutionScreenState extends State<SessionExecutionScreen> {
  final List<Map<String, dynamic>> exercises = [
    {'name': 'Pompes', 'reps': 20, 'duration': 30},
    {'name': 'Squats', 'reps': 30, 'duration': 30},
    {'name': 'Burpees', 'reps': 15, 'duration': 30},
  ];

  int currentExercise = 0;
  late int timeLeft;

  @override
  void initState() {
    super.initState();
    timeLeft = (widget.type == 'HIIT' || widget.type == 'EMON')
        ? exercises[currentExercise]['duration']
        : widget.duration * 60;
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          if (widget.type == 'HIIT' || widget.type == 'EMON') {
            nextExercise();
          } else if (widget.type == 'AMRAP') {
            endSession(); 
          }
        }
      });
    });
  }

  void nextExercise() {
    if (currentExercise < exercises.length - 1) {
      setState(() {
        currentExercise++;
        timeLeft = exercises[currentExercise]['duration'];
      });
      startTimer();
    } else {
      endSession(); 
    }
  }

  void endSession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionEndScreen(type: widget.type, sessionName: widget.title, exercises: exercises, sessionDuration: widget.duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.type == 'HIIT' || widget.type == 'EMON')
        ? timeLeft / exercises[currentExercise]['duration']
        : 1 - (widget.duration * 60 - timeLeft) / (widget.duration * 60);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: (widget.type == 'AMRAP')
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var exercise in exercises)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${exercise['name']} :',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${exercise['reps']} répétitions',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                  const SizedBox(height: 150),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 150,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                        Text(
                          '${Duration(seconds: timeLeft).toString().split('.').first}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : (widget.type == 'HIIT' || widget.type == 'EMON')
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '${exercises[currentExercise]['name']}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 150),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 150,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '${Duration(seconds: timeLeft).toString().split('.').first}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text('Type non géré'),
                ),
    );
  }
}
