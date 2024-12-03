import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/themes/color.dart'; 
import 'package:zenfit/themes/dark_mode.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String selectedColorTheme = 'Bleu'; 
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? '';
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<DarkModeProvider>().isDarkMode;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    Color themeColor = context.watch<ThemeColorProvider>().themeColor;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accéder à vos informations personnelles',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: TextEditingController(text: email),
              enabled: false,
              decoration: InputDecoration(
                hintText: email.isEmpty ? 'test@zenfit.com' : email,
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 30),
            Text(
              'Les paramètres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Passer en mode sombre', style: TextStyle(color: textColor)),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    context.read<DarkModeProvider>().toggleDarkMode();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedColorTheme,
              items: ['Bleu', 'Rouge', 'Vert'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: textColor)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedColorTheme = newValue!;
                  context.read<ThemeColorProvider>().updateThemeColor(newValue);
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                ),
                child: const Text(
                  'Se déconnecter',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
