import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  final String broker = 'test.mosquitto.org';
  final int port = 1883;
  final List<String> topics;
  final _controller = StreamController<String>.broadcast();

  MqttServerClient? _client;

  MQTTManager({required this.topics});

  Stream<String> get messageStream => _controller.stream;

  Future<void> initializeMQTTClient() async {
    _client = MqttServerClient(broker, '');
    _client!.port = port;
    _client!.logging(on: false);
    _client!.setProtocolV311();

    try {
      await _client!.connect();
    } on Exception catch (e) {
      print('Exception: $e');
      _client!.disconnect();
      return;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected');
      _subscribeToTopics();
    } else {
      print(
          'ERROR: MQTT client connection failed - disconnecting, status is ${_client!.connectionStatus}');
      _client!.disconnect();
    }
  }

  void _subscribeToTopics() {
    for (String topic in topics) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
    }

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print("MQTT message received: $message"); // Add this line
      _controller.add(message);
    });
  }

  void dispose() {
    _controller.close();
    _client?.disconnect();
  }
}
