import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import '../database.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires')),
      );
      return;
    }

    try {
      print("Tentative de connexion avec email : $email");
  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  print("Connexion réussie pour l'utilisateur : ${userCredential.user?.email}");
  // Navigation si succès
  Navigator.of(context).pushReplacementNamed('/main');
    } on FirebaseAuthException catch (e) {
      String message = 'Erreur inconnue';
      if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect';
      } else if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouvé pour cet email';
      } else if (e.code == 'invalid-email') {
        message = 'Email invalide';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        Navigator.of(context).pushReplacementNamed('/main');

        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          UserCredential userCredential = await _auth.signInWithCredential(credential);

          User? user = userCredential.user;
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        } else {
          throw Exception("Token d'accès ou ID manquant.");
        }
      }
    } catch (error) {
      print('Erreur lors de la connexion avec Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la connexion avec Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/logo-icon.png',
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Connexion',
                  style: TitleStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  'Connectez-vous à ZenFit !',
                  style: ContentTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _emailController,
                    decoration: greyInput(context).copyWith(
                      labelText: 'Email'
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: greyInput(context).copyWith(
                      labelText: 'Mot de passe'
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _signin,
                  style: BleuButtonStyle(context),
                  child: const Text(
                    'CONNEXION',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('ou'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _googleLogin,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFDB4437), // Couleur Google
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                  ),
                  child: const Text(
                    'Se connecter avec Google',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Pas encore inscrit ?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/registration');
                  },
                  child: const Text('Inscrivez-vous !'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
