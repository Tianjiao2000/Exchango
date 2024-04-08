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
      if (message.contains('Humidity')) {
        setState(() {
          humidity = message;
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
      child: Center(child: Text(humidity)),
    );
  }
}
