import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';
import '../models/sensor_data.dart';

class WearableScreen extends StatefulWidget {
  const WearableScreen({super.key});

  @override
  _WearableScreenState createState() => _WearableScreenState();
}

class _WearableScreenState extends State<WearableScreen> {
  final MqttService _mqttService = MqttService();
  String _clima = 'null';
  int _paso = 0;
  int _temperatura = 0;
  double _bateria = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reconnectMqtt();
  }

  void _reconnectMqtt() {
    _mqttService.disconnect(); // Desconectar antes de volver a conectar
    _mqttService.connect(
      [
        'wearable/clima/data',
        'wearable/paso/data',
        'wearable/temperatura/data',
        'wearable/batteria/data',
      ],
      _onDataReceived,
    );
  }

  void _onDataReceived(SensorData data) {
    setState(() {
      switch (data.type) {
        case 'wearable_clima':
          if (data.value is String) {
            _clima = data.value as String;
          }
          break;
        case 'wearable_paso':
          if (data.value is int) {
            _paso = data.value as int;
          }
          break;
        case 'wearable_temperatura':
          if (data.value is int) {
            _temperatura = data.value as int;
          }
          break;
        case 'wearable_batteria':
          if (data.value is double) {
            _bateria = data.value as double;
          } else if (data.value is int) {
            _bateria = (data.value as int).toDouble();
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect(); // Desconectar al salir de la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wearable Data'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDataCard('Clima', _clima, Icons.cloud),
            _buildDataCard('Pasos', _paso, Icons.directions_walk),
            _buildDataCard('Temperatura','$_temperatura°C', Icons.thermostat),
            _buildDataCard('Batería', _bateria, Icons.battery_charging_full),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String label, dynamic value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 50, color: Colors.deepPurple),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatValue(value),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value is int) {
      return value.toString();  // Devuelve el valor entero tal cual
    } else if (value is double) {
      return value.toStringAsFixed(2);  // Formatea el valor double con 2 decimales
    } else if (value is String) {
      return value;  // Devuelve la cadena tal cual
    } else {
      return 'N/A';  // En caso de que sea otro tipo inesperado
    }
  }
}
