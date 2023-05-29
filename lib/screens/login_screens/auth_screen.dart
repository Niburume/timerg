import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timerg/screens/login_screens/login_or_register_screen.dart';
import 'package:timerg/screens/login_screens/login_screen.dart';
import 'package:timerg/screens/main_screen.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth_screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
