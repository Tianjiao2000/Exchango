import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final String broker = 'test.mosquitto.org';
  final String clientIdentifier = 'flutter_mqtt_client';
  final List<String> topics = ['button_press_topic', 'temperature', 'humidity'];
  late MqttServerClient client;
  final StreamController<String> _messageController =
      StreamController.broadcast();
  static final MQTTService _instance = MQTTService._internal();

  factory MQTTService() {
    return _instance;
  }

  MQTTService._internal() {
    client = MqttServerClient(broker, clientIdentifier);
    client.logging(on: false);
  }

  Stream<String> get messageStream => _messageController.stream;

  Future<void> initializeMQTTClient() async {
    // Check if the client is already connected
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      await client.connect();
      print('MQTT Client Connected');

      // Subscribe to all topics
      for (String topic in topics) {
        client.subscribe(topic, MqttQos.atLeastOnce);
      }

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        _messageController.add(payload);
        print('Received Message: $payload'); // For debugging
      });
    }
  }

  void dispose() {
    _messageController.close();
    client.disconnect();
  }
}



// class MQTTService {
//   final String broker = 'test.mosquitto.org';
//   final String clientIdentifier = 'flutter_mqtt_tempBlock';
//   final List<String> topics = ['button_press_topic', 'temperature']; // 添加温度主题
//   late MqttServerClient client;
//   final StreamController<String> _messageController = StreamController.broadcast();

//   Stream<String> get messageStream => _messageController.stream;

//   Future<void> initializeMQTTClient() async {
//     client = MqttServerClient(broker, clientIdentifier);
//     client.logging(on: false);
//     await client.connect();

//     print('MQTT Client Connected');

//     // Subscribe to all topics
//     for (String topic in topics) {
//       client.subscribe(topic, MqttQos.atLeastOnce);
//     }

//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//       final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
//       _messageController.add(payload);
//     });
//   }

//   void dispose() {
//     _messageController.close();
//     client.disconnect();
//   }
// }


// class MQTTService {
//   final String broker = 'test.mosquitto.org';
//   final String clientIdentifier = 'flutter_mqtt_tempBlock';
//   final String topic = 'button_press_topic';
//   late MqttServerClient client;
//   final StreamController<String> _messageController = StreamController.broadcast();

//   Stream<String> get messageStream => _messageController.stream;

//   Future<void> initializeMQTTClient() async {
//     client = MqttServerClient(broker, clientIdentifier);
//     client.logging(on: false);
//     await client.connect();

//     print('MQTT Client Connected');

//     client.subscribe(topic, MqttQos.atLeastOnce);

//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//       final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
//       _messageController.add(payload);
//     });
//   }

//   void dispose() {
//     _messageController.close();
//     client.disconnect();
//   }
// }
