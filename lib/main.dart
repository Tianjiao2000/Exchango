import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_options.dart';
import 'StartPage.dart';
import 'notification/notification_schedule.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'ActivityPage/button_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification/notification_schedule.dart';
import 'api/OpenWeatherMap.dart';

// 添加MethodChannel
const platform = MethodChannel('com.example.flutter_demo/mqtt');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'name-here',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDJu9L-St7svqxBh3cBAWpmj_XlsGF6tJ4',
      appId: '1:696675160605:ios:4a914032b8223161a9ecf4',
      messagingSenderId: '696675160605',
      projectId: 'ce-mobile-b600c',
    ),
  );

  _configureStaticTimeZone();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // 启动MQTT服务
  startMQTTService();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

void startMQTTService() async {
  try {
    await platform.invokeMethod('startService');
  } on PlatformException catch (e) {
    print("Failed to start MQTT service: '${e.message}'.");
  }
}

void _configureStaticTimeZone() {
  tz.initializeTimeZones();
  var location = tz.getLocation('Europe/London');
  tz.setLocalLocation(location);
}

Future<void> checkNotificationPermission(BuildContext context) async {
  final notificationService = NotificationService();
  await notificationService.checkNotificationPermission(context);
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkNotificationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget.isLoggedIn ? BottomNavigation() : StartPage(),
    );
  }
}
