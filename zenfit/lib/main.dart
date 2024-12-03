import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Import de provider
import 'package:zenfit/layout/main_page.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'package:zenfit/views/onboarding_screen.dart';
import 'package:zenfit/views/home_screen.dart';
import 'package:zenfit/views/registration_screen.dart';
import 'package:zenfit/views/signin_screen.dart';
import 'package:zenfit/views/historic_screen.dart';
import 'package:zenfit/views/planning_screen.dart';
import 'package:zenfit/themes/color.dart';
import 'package:zenfit/themes/dark_mode.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/db/database_helper.dart';
import 'package:zenfit/db/initialize_exercises.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialiser la base de données
  final db = await DatabaseHelper.instance.database;

  // Vous pouvez effectuer des opérations si nécessaire, par exemple initialiser des données
  print('Base de données initialisée : $db');

  await initializeExercises();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Utilisation de MultiProvider pour inclure plusieurs providers
      providers: [
        ChangeNotifierProvider(create: (_) => DarkModeProvider()), // Ajout du provider DarkModeProvider
        ChangeNotifierProvider(create: (_) => ThemeColorProvider()), // Ajout du provider ThemeColorProvider
      ],
      child: Consumer2<DarkModeProvider, ThemeColorProvider>(
        builder: (context, darkModeProvider, themeColorProvider, _) {
          return MaterialApp(
            title: 'Zenfit',
            debugShowCheckedModeBanner: false,
            themeMode: darkModeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light().copyWith(
              primaryColor: themeColorProvider.themeColor, // Utilisation de la couleur de thème dynamique
              appBarTheme: AppBarTheme(
                color: themeColorProvider.themeColor, // Appliquer la couleur du thème à l'AppBar
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorProvider.themeColor, // Couleur des boutons
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: themeColorProvider.themeColor, // Couleur de thème dynamique pour le mode sombre
              appBarTheme: AppBarTheme(
                color: themeColorProvider.themeColor, // Appliquer la couleur du thème à l'AppBar
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorProvider.themeColor, // Couleur des boutons
                ),
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  if (user != null) {
                    return const MainPage(); // Page principale après la connexion
                  }
                  return const OnboardingScreen(); // Page d'onboarding si pas connecté OnboardingScreen()
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            routes: {
              '/main': (context) => const MainPage(),
              '/registration': (context) => const RegistrationScreen(),
              '/signin': (context) => const SigninScreen(),
              '/home': (context) => HomeScreen(),
              '/planning': (context) => PlanningScreen(),
              '/historic': (context) => const HistoricScreen(),
              '/profil': (context) => const ProfilScreen(),
            },
          );
        },
      ),
    );
  }
}
