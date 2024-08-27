import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';
import 'package:uuid/uuid.dart';


class MqttService {
  static final MqttService _instance = MqttService._internal();

  factory MqttService() {
    return _instance;
  }

  MqttService._internal() 
    : client = MqttServerClient('broker.emqx.io', Uuid().v4());

  final MqttServerClient client;
  bool isConnected = false;
  Function(SensorData)? onDataReceived;

  Future<void> connect(List<String> topics, Function(SensorData) onDataReceivedCallback) async {
    onDataReceived = onDataReceivedCallback;

    if (isConnected) {
      _subscribeToTopics(topics);
      return;
    }

    try {
      await client.connect();
      isConnected = client.connectionStatus?.state == MqttConnectionState.connected;

      if (isConnected) {
        _subscribeToTopics(topics);
      } else {
        client.disconnect();
      }
    } catch (e) {
      print('Error al conectar a MQTT: $e');
      client.disconnect();
    }
  }

  void _subscribeToTopics(List<String> topics) {
    for (var topic in topics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    }

    client.updates!.listen(_onMessage);
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String topic = event[0].topic;
    final String payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final dynamic value = _parseValue(payload);

    final sensorType = _determineSensorType(topic);
    final sensorData = SensorData(sensorType, value);
    if (onDataReceived != null) {
      onDataReceived!(sensorData);
    }
  }

dynamic _parseValue(String payload) {
  if (int.tryParse(payload) != null) {
    return int.parse(payload);
  } else if (double.tryParse(payload) != null) {
    return double.parse(payload);
  } else {
    return payload;  // Si no es un número, tratarlo como String
  }
}


 String _determineSensorType(String topic) {
  if (topic == 'project/luz/data') {
    return 'luz';
  } else if (topic == 'project/temperatura/data') {
    return 'temperatura';
  } else if (topic == 'project/humedad/data') {
    return 'humedad';
  } else if (topic == 'project/gas/data') {
    return 'gas';
  } else if (topic == 'project/ventilador/data') {
    return 'ventilador';
  } else if (topic == 'project/music/data') {
    return 'music';
  } else if (topic == 'project/system/data') {
    return 'system';
  } else if (topic == 'wearable/clima/data') {
    return 'wearable_clima';
  } else if (topic == 'wearable/paso/data') {
    return 'wearable_paso';
  } else if (topic == 'wearable/batteria/data') {
    return 'wearable_batteria';
  } else if (topic == 'wearable/temperatura/data') {
    return 'wearable_temperatura';
  } else {
    return 'unknown';
  }
}

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    final retain = (
                    topic == 'project/music/data' ||
                    topic == 'project/ventilador/data');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: retain);
  }
  

  void disconnect() {
    client.disconnect();
    isConnected = false;
  }
}