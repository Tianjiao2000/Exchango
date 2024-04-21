import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ButtonDetailsPage.dart';
import 'button_info.dart';
import 'mqtt_subscriber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../notification/notification_schedule.dart';

class ButtonBlock extends StatefulWidget {
  final List<Map<String, dynamic>> sortedButtonData;

  ButtonBlock({Key? key, required this.sortedButtonData}) : super(key: key);

  @override
  _ButtonBlockState createState() => _ButtonBlockState();
}

class _ButtonBlockState extends State<ButtonBlock> {
  List<Map<String, dynamic>> sortedButtonData = [];
  // ButtonBlock({Key? key, required this.sortedButtonData}) : super(key: key);
  final MQTTService _mqttService = MQTTService();
  String message = 'Waiting for MQTT messages...';
  final NotificationService notificationSchedule = NotificationService();

  @override
  void initState() {
    super.initState();
    // sortedButtonData = widget.sortedButtonData;
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message);
      if (message.contains('Button')) {
        _addButtonData('Food');
        _scheduleButtonPressNotification('Food');
      }
    });
    _loadButtonData(); // load saved info
    notificationSchedule.initialize();
  }

  Future<void> _scheduleButtonPressNotification(String buttonName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    String petName = prefs.getString('${email}_petName') ?? 'Your pet';
    String body = '$petName wants $buttonName!';

    // schedule notification
    await notificationSchedule.scheduleNotification(
      0, // id
      'Button Pressed', // title
      body, // content
      DateTime.now().add(Duration(seconds: 5)), // delay 5s
    );
  }

  // Future<void> _loadButtonData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = FirebaseAuth.instance.currentUser?.email ?? '';
  //   String storedData = prefs.getString('${email}_buttonData') ?? '[]';
  //   List<dynamic> jsonData = json.decode(storedData);
  //   List<Map<String, dynamic>> loadedData = jsonData.map((item) {
  //     return {
  //       'name': item['name'],
  //       'datetime': DateTime.parse(item['datetime'])
  //     };
  //   }).toList();
  //   setState(() {
  //     sortedButtonData = loadedData;
  //   });
  // }
  Future<void> _loadButtonData() async {
    List<Map<String, dynamic>> loadedData = buttonData.map((item) {
      return {
        'name': item['name'],
        'datetime': DateTime.parse(item['datetime'])
      };
    }).toList();
    setState(() {
      sortedButtonData = loadedData;
    });
  }

  void _addButtonData(String name) async {
    final now = DateTime.now();
    setState(() {
      sortedButtonData.insert(0, {'name': name, 'datetime': now});
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    String encodedData = json.encode(sortedButtonData.map((item) {
      return {
        'name': item['name'],
        'datetime': item['datetime'].toIso8601String()
      };
    }).toList());
    await prefs.setString('${email}_buttonData', encodedData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF27f0c),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buttons',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ButtonDetailsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedButtonData.length,
              itemBuilder: (context, index) {
                var buttonInfo = sortedButtonData[index];
                Color bgColor = Color.fromARGB(
                    255, 239, 239, 239); // Default background color
                if (index < 6) {
                  double opacity = 1 - (index * 0.2);
                  bgColor =
                      Color.fromARGB(255, 255, 182, 47).withOpacity(opacity);
                }

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                      buttonInfo['name'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd – kk:mm')
                          .format(buttonInfo['datetime']),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
