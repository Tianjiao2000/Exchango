import 'package:flutter/material.dart';
import 'mqtt_subscriber.dart';

class TempBlock extends StatefulWidget {
  @override
  _TempBlockState createState() => _TempBlockState();
}

class _TempBlockState extends State<TempBlock> {
  final MQTTService _mqttService = MQTTService();
  String temperature = 'Waiting for temperature...';

  @override
  void initState() {
    super.initState();
    // get the mqtt info by message content
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message);
      if (message.contains('Temperature')) {
        final parts = message.split('Temperature = ');
        // get the temp value
        if (parts.length > 1) {
          final tempValue = parts[1];
          setState(() {
            temperature = tempValue;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mqttService.dispose();
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
                  'Temperature',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                temperature,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
