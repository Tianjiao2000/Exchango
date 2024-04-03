// import 'package:flutter/material.dart';
// import 'mqtt_subscriber.dart';
// import 'package:intl/intl.dart'; // Import the intl package

// class TempBlock extends StatefulWidget {
//   @override
//   _TempBlockState createState() => _TempBlockState();
// }

// class _TempBlockState extends State<TempBlock> {
//   final MQTTService _mqttService = MQTTService();
//   String message = 'Waiting for MQTT messages...';

//   @override
//   void initState() {
//     super.initState();
//     _mqttService.initializeMQTTClient();
//     _mqttService.messageStream.listen((msg) {
//       // Get the current time
//       final String currentTime =
//           DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
//       // print(msg);
//       setState(() {
//         // Update the message to include the time it was received
//         message = "$msg\nReceived at $currentTime";
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(child: Text(message)),
//     );
//   }

//   @override
//   void dispose() {
//     _mqttService.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';

class TempBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text('Temp')),
    );
  }
}
