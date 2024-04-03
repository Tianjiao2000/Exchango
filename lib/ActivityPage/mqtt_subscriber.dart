import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final String broker = 'test.mosquitto.org';
  final String clientIdentifier = 'flutter_mqtt_tempBlock';
  final String topic = 'button_press_topic';
  late MqttServerClient client;
  final StreamController<String> _messageController = StreamController.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  Future<void> initializeMQTTClient() async {
    client = MqttServerClient(broker, clientIdentifier);
    client.logging(on: false);
    await client.connect();

    print('MQTT Client Connected');

    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      _messageController.add(payload);
    });
  }

  void dispose() {
    _messageController.close();
    client.disconnect();
  }
}
