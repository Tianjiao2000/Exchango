import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'AccountPage/StartPage.dart';
import 'notification/notification_schedule.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure local timezone
  await _configureLocalTimeZone();

  // Initialize notifications
  NotificationSchedule().initNotification();

  runApp(MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(home: BottomNavigation());
    return MaterialApp(home: AccountPage());
  }
}
