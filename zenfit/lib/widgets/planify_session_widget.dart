import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/views/home_screen.dart';


class PlanifySessionWidget extends StatefulWidget {

  final List<Session> sessionList;
  final Session newSession;

  const PlanifySessionWidget({Key? key, required this.sessionList, required this.newSession}) : super(key: key);

  @override
  _PlanifySessionWidget createState() => _PlanifySessionWidget();
}

class _PlanifySessionWidget extends State<PlanifySessionWidget> {
  final TextEditingController _sessionNameController = TextEditingController();
  String _sessionName = "";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _selectedReminder = 0;

  final List<int> _reminderOptions = [5 , 15 , 30, 45];

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitSession() {
    if (_sessionNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer le nom de la séance')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une date')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une heure')),
      );
      return;
    }

    if (_selectedReminder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un rappel')),
      );
      return;
    }

    final addSession = Session(
      name: _sessionName,
      sessionType: widget.newSession.sessionType,
      exercises: widget.newSession.exercises,
      duration: widget.newSession.duration,
      date:  DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      reminder: _selectedReminder,
    );

    setState(() {
      widget.sessionList.add(addSession);
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Planifier votre séance',
            style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: whiteIcon,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: greyInput.copyWith(
                labelText: "Nom de l'exercice (personnalisé)",
              ),
              onChanged: (String value) {
                setState(() {
                  _sessionName = value;
                });
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: greyInput.copyWith(labelText: 'Date'),
                child: Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Sélectionnez une date',
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectTime,
              child: InputDecorator(
                decoration: greyInput.copyWith(labelText: 'Heure'),
                child: Text(
                  _selectedTime != null
                      ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Sélectionnez une heure',
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: greyInput.copyWith(labelText: 'Rappels'),
              value: _selectedReminder,
              items: _reminderOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value min'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReminder = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submitSession,
                child: const Text('CONFIRMER LA SÉANCE'),
                style: BleuButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
