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
    _mqttService.initializeMQTTClient();
    _mqttService.messageStream.listen((message) {
      print(message);
      if (message.contains('Temperature')) {
        setState(() {
          temperature = message;
        });
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(temperature)),
    );
  }
}
