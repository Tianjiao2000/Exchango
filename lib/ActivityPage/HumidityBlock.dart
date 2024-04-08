import 'package:flutter/material.dart';
import 'mqtt_subscriber.dart';

class HumidityBlock extends StatefulWidget {
  @override
  _HumidityBlockState createState() => _HumidityBlockState();
}

class _HumidityBlockState extends State<HumidityBlock> {
  final MQTTService _mqttService = MQTTService();
  String humidity = 'Waiting for humidity...';

  @override
  void initState() {
    super.initState();
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message); // For debugging
      if (message.contains('Humidity')) {
        // split humidiity string to get value
        final parts = message.split('Humidity = ');
        if (parts.length > 1) {
          final humidityValue = parts[1];
          setState(() {
            humidity = humidityValue;
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
                  'Humidity',
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
                humidity,
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
