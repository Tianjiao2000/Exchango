import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ButtonDetailsPage.dart';
import 'button_info.dart';
import 'mqtt_subscriber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

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
  @override
  void initState() {
    super.initState();
    // sortedButtonData = widget.sortedButtonData;
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message);
      if (message.contains('Button')) {
        _addButtonData('Food');
      }
    });
    _loadButtonData(); // load saved info
  }

  Future<void> _loadButtonData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    String storedButtonData = prefs.getString('${email}_buttonData') ?? '';
    if (storedButtonData.isNotEmpty) {
      // 本地存储中有数据，解码并加载
      List<dynamic> decodedData = json.decode(storedButtonData);
      setState(() {
        sortedButtonData = decodedData.map<Map<String, dynamic>>((item) {
          DateTime dt = DateTime.parse(item['datetime']);
          return {'name': item['name'], 'datetime': dt};
        }).toList();
      });
    } else {
      // 本地存储中没有数据，加载默认值
      setState(() {
        sortedButtonData = widget.sortedButtonData;
      });
    }
  }

  void _addButtonData(String name) async {
    final now = DateTime.now();
    setState(() {
      sortedButtonData.insert(0, {'name': name, 'datetime': now});
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    // 将日期转换为字符串格式以便保存
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
