import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';
import 'package:provider/provider.dart'; // Import de provider
import 'package:zenfit/themes/color.dart'; // Import du ThemeColorProvider
import 'package:zenfit/themes/dark_mode.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String selectedColorTheme = 'Bleu'; // Valeur par défaut
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Récupérer l'email de l'utilisateur connecté
  void _loadUserData() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? ''; // On récupère l'email de l'utilisateur connecté
      });
    }
  }

  // Fonction pour se déconnecter
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin'); // Redirige vers la page de connexion
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de l'état du mode sombre via le provider
    bool isDarkMode = context.watch<DarkModeProvider>().isDarkMode;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    // Récupérer la couleur du thème sélectionné à partir du ThemeColorProvider
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
            // Champ Email prérempli avec l'email de l'utilisateur
            TextField(
              controller: TextEditingController(text: email),
              enabled: false, // Le champ est en lecture seule (non modifiable)
              decoration: InputDecoration(
                hintText: email.isEmpty ? 'test@zenfit.com' : email,
                filled: true,
                fillColor: backgroundColor, // Couleur de fond dynamique
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
                    context.read<DarkModeProvider>().toggleDarkMode(); // Mise à jour du mode sombre
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Sélection du thème de couleur
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
                  // Mettre à jour la couleur du thème via le ThemeColorProvider
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
            // Bouton de déconnexion centré avec padding supplémentaire
            Center(
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor, // Utiliser la couleur du thème pour le bouton
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
// Assurez-vous que votre BottomBar utilise également la couleur du thème
    );
  }
}
