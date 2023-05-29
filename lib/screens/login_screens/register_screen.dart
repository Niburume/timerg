import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timerg/Models/user_model.dart';
import 'package:timerg/components/login_textfield.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/constants/constants.dart';
import 'package:timerg/helpers/db_helper.dart';

import '../../components/square_tile.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register_screen';
  final Function()? onTap;
  RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.person,
                  size: 40,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text('Register you now'),
                const SizedBox(
                  height: 25,
                ),
                LoginTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                LoginTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                LoginTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                GeneralButton(
                  onTap: signUserUp,
                  title: 'Register',
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/assets/images/apple_logo2.png'),
                    SizedBox(
                      width: 100,
                    ),
                    SquareTile(imagePath: 'lib/assets/images/google_logo.jpg'),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'LogIn',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // try sign in

    if (passwordController.text == confirmPasswordController.text) {
      String email = emailController.text;
      String password = passwordController.text;

      String requestStatus =
          await DBHelper.instance.createUser(email, password);
      Navigator.pop(context);
      showErrorMessage('The password provided is too weak.');
      if (requestStatus == 'weak-password') {
        showErrorMessage('The password provided is too weak.');
      } else if (requestStatus == 'email-already-in-use') {
        showErrorMessage('The account already exists for that email.');
      }
    } else {
      Navigator.pop(context);
      showErrorMessage('Password is not the same');
    }
  }

  // error message to user
  void showErrorMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        });
  }
}
