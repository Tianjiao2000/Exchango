import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ButtonDetailsPage.dart';
import 'button_info.dart';
import 'mqtt_subscriber.dart';

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
    sortedButtonData = widget.sortedButtonData;
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message);
      if (message.contains('Button')) {
        _addButtonData('Food');
      }
    });
  }

  void _addButtonData(String name) {
    final now = DateTime.now();
    setState(() {
      sortedButtonData.insert(0, {
        'name': name,
        'datetime': now,
      });
    });
    // print(sortedButtonData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF06236),
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
                Color bgColor = Colors.white; // Default background color
                if (index < 6) {
                  double opacity = 1 - (index * 0.2);
                  bgColor =
                      Color.fromARGB(255, 249, 119, 79).withOpacity(opacity);
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
