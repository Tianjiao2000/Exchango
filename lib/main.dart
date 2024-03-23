import 'package:flutter/material.dart';
import 'navigation.dart';
// import 'pages/CurrencyPage.dart';

// import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 用于Firebase初始化的自动生成的文件

import 'package:firebase_auth/firebase_auth.dart';

// void main() => runApp(const MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: BottomNavigation(),
      home: BottomNavigation(
        
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';


