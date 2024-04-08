import 'package:flutter/material.dart';
import 'mqtt_subscriber.dart';

class SoundBlock extends StatefulWidget {
  @override
  _SoundBlockState createState() => _SoundBlockState();
}

class _SoundBlockState extends State<SoundBlock> {
  final MQTTService _mqttService = MQTTService();
  String sound = 'Waiting for sound level...';

  @override
  void initState() {
    super.initState();
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message); // For debugging
      if (message.contains('Sound')) {
        // split sound string to get the value
        final parts = message.split('Sound level: ');
        if (parts.length > 1) {
          final soundValue = parts[1];
          setState(() {
            sound = soundValue;
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
                  'Sound Level',
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
                sound,
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
