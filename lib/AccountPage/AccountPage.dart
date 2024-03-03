import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
              keyboardType: TextInputType.emailAddress, // Use email input type for usernames
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
              onPressed: () {
                // Implement login logic
                print('Username: ${_usernameController.text}');
                print('Password: ${_passwordController.text}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
