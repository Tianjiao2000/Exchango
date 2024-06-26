import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api/firebase_options.dart';
import 'navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ActivityPage/button_info.dart';

class StartPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color commonColor = Color(0xFFF27F0C);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: commonColor),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/petpat.jpg',
              width: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: commonColor),
                    ),
                    cursorColor: commonColor,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: commonColor),
                    ),
                    obscureText: true,
                    cursorColor: commonColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _login(emailController.text, passwordController.text,
                            context);
                      },
                      child:
                          Text('Login', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: commonColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _signup(emailController.text, passwordController.text,
                          context);
                    },
                    child: Text('Don\'t have an account? Sign up',
                        style: TextStyle(color: commonColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      _resetPassword(emailController.text, context);
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(color: commonColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        // Email not verified, inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Your email is not verified. Please check your inbox or spam for the verification link.'),
            backgroundColor:
                Colors.orange, // To draw attention but differentiate from error
          ),
        );

        //resend the verification email
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Verification email resent. Please check your email.'),
            backgroundColor:
                Colors.green, // Indicate a helpful action has been taken
          ),
        );

        // Prevent navigating to the next screen since email is not verified
        return;
      }

      // Email is verified, proceed with login
      if (user != null && user.emailVerified) {
        // save login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'Please enter your email and password.'; // Default error message
      switch (e.code) {
        case 'invalid-credential':
          // case 'wrong-password': // Adding specific case for wrong password
          errorMessage =
              'Please check your password or provide a registered account.';
          break;
        case 'invalid-email':
          errorMessage = 'Please provide a valid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        //   errorMessage = 'No account found for that email.';
        //   break;
      }

      // Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red, // To make it more noticeable
        ),
      );
    } catch (e) {
      // For other errors that are not FirebaseAuthException
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red, // To make it more noticeable
        ),
      );
      print("Login failed: $e");
    }
  }

  void _signup(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Signup successful

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        // Show a message to check their email for verification link
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'A verification email has been sent. Please check your inbox or spam.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Please enter your email and password.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use. If you haven\'t verified your email, please check your inbox for the verification link.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  void _resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Password reset email sent. Please check your inbox or spam.'),
        ),
      );
    } catch (e) {
      // Error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email.'),
        ),
      );
      print("Password reset failed: $e");
    }
  }
}
