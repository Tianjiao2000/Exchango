import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'StartPage.dart';
import 'notification/notification_schedule.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Firebase.initializeApp(
    name: 'name-here',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDJu9L-St7svqxBh3cBAWpmj_XlsGF6tJ4',
      appId: '1:696675160605:ios:4a914032b8223161a9ecf4',
      messagingSenderId: '696675160605',
      projectId: 'ce-mobile-b600c',
    ),
  );

  // Configure local timezone statically (you can adjust the location as needed)
  _configureStaticTimeZone();

  // Initialize notifications
  // NotificationSchedule().initNotification();
  await NotificationService().initialize();

  runApp(MyApp());
}

void _configureStaticTimeZone() {
  tz.initializeTimeZones();
  var location = tz.getLocation('Europe/London');
  tz.setLocalLocation(location);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartPage());
  }
}
