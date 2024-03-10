import 'package:flutter/material.dart';
import 'navigation.dart';
// import 'pages/CurrencyPage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 用于Firebase初始化的自动生成的文件

import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(const MyApp());
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: BottomNavigation(),
      home: BottomNavigation(),
    );
  }
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Auth Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             controller: passwordController,
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _login(emailController.text, passwordController.text);
//             },
//             child: Text('Login'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _login(String email, String password) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: "tjw@gmail.com",
//         password: "123456",
//       );
//       // 登录成功后的处理
//       print("登录成功");
//     } catch (e) {
//       // 登录失败后的处理
//       print(e);
//     }
//   }
// }
