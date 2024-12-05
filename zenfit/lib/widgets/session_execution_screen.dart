import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zenfit/widgets/session_end_screen.dart';

class SessionExecutionScreen extends StatefulWidget {
  final String title;
  final int duration;
  final String type;
  final List<Map<String, dynamic>> exercices;
  final DateTime sessionDate;
  final int? sessionId;
  final int sessionReminder;


  const SessionExecutionScreen({
    Key? key,
    required this.title,
    required this.duration,
    required this.type,
    required this.exercices,
    required this.sessionDate,
    required this.sessionId,
    required this.sessionReminder,
  }) : super(key: key);

  @override
  _SessionExecutionScreenState createState() => _SessionExecutionScreenState();
}

class _SessionExecutionScreenState extends State<SessionExecutionScreen> {
  int currentExercise = 0;
  late int timeLeft;

  @override
  void initState() {
    super.initState();
    print("Exercices disponibles: ${widget.exercices}");

    if (widget.exercices.isNotEmpty) {
      timeLeft = (widget.type == 'HIIT' || widget.type == 'EMOM')
          ? widget.exercices[currentExercise]['duration'] ?? 0
          : widget.duration * 60;
    } else {
      timeLeft = 0;
    }

    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          if (widget.type == 'HIIT' || widget.type == 'EMOM') {
            nextExercise();
          } else if (widget.type == 'AMRAP') {
            endSession();
          }
        }
      });
    });
  }

  void nextExercise() {
    if (currentExercise < widget.exercices.length - 1) {
      setState(() {
        currentExercise++;
        timeLeft = widget.exercices[currentExercise]['duration'] ?? 0;
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
        builder: (context) => SessionEndScreen(
          sessionId: widget.sessionId,
          type: widget.type,
          sessionName: widget.title,
          sessionDate: widget.sessionDate,
          sessionReminder: widget.sessionReminder,
          exercises: widget.exercices,
          sessionDuration: widget.duration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.type == 'HIIT' || widget.type == 'EMOM')
        ? (widget.exercices[currentExercise]['duration'] > 0
            ? timeLeft / widget.exercices[currentExercise]['duration']
            : 0)
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
                  for (var exercise in widget.exercices)
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
          : (widget.type == 'HIIT' || widget.type == 'EMOM')
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '${widget.exercices[currentExercise]['name']}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Affichage centré du nombre de répétitions pour EMOM
                      if (widget.type == 'EMOM')
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Center(  // Centrer le texte des répétitions
                            child: Text(
                              '${widget.exercices[currentExercise]['reps']} répétitions',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
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
