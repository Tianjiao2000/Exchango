import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatelessWidget {
  // TextEditingControllers to collect username and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show error message if email or password is empty
      print('Email and password cannot be empty');
      return;
    }

    try {
      // 使用Firebase Auth进行邮箱和密码登录
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 登录成功
      print('Login successful: ${userCredential.user}');

      // 可以在这里进行页面跳转或状态更新
    } on FirebaseAuthException catch (e) {
      // 处理登录过程中可能发生的错误
      print('Login error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Username TextField
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType
                  .emailAddress, // Use email input type for usernames
            ),
            SizedBox(height: 20), // Space between input fields
            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide password text
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20), // Space before the login button
            // Login Button
            ElevatedButton(
              child: Text('Login'),
              onPressed: _login, // Update this line
            ),
          ],
        ),
      ),
    );
  }
}
