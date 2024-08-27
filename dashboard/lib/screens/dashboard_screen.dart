import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/mqtt_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MqttService _mqttService = MqttService();
  bool _fanOn = false, _speakerOn = false, _systemOn = false;

  @override
  void initState() {
    super.initState();
    _mqttService.connect(['project/ventilador/data','project/music/data', 'project/system/data'], _onDataReceived);
  }

  void _onDataReceived(SensorData data) {
    setState(() {
      switch (data.type) {
        case 'ventilador':
          _fanOn = _parseString(data.value) == '1';
          break;
        case 'music':
          _speakerOn = _parseString(data.value) == '1';
          break;
        case 'system':
          _systemOn = _parseString(data.value) == '1';
          break;
      }
    });
  }

  String _parseString(dynamic value) {
    if (value is String) {
      return value;
    } else {
      return value.toString();  // Convierte cualquier valor a String
    }
  }

void _toggleFan(bool turnOn) {
  if (_mqttService.isConnected) {
    final message = turnOn ? '1' : '0';
    _mqttService.publish('project/ventilador/data', message);
    setState(() {
      _fanOn = turnOn;
    });
  } else {
    // Maneja la situación donde la conexión no está activa
    print('No hay conexión activa a MQTT');
  }
}

  void _toggleSpeaker(bool turnOn) {
    if (_mqttService.isConnected) {
    final message = turnOn ? '1' : '0';
    _mqttService.publish('project/music/data', message);
    setState(() {
      _speakerOn = turnOn;
    });
  } else {
    // Maneja la situación donde la conexión no está activa
    print('No hay conexión activa a MQTT');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Ajuste del padding vertical
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActuatorTile('Ventilador', _fanOn, _toggleFan),
                _buildActuatorTile('Bocina', _speakerOn, _toggleSpeaker),
                _buildSystemControlTile('Sistema', _systemOn),
              ],
            ),
            const SizedBox(height: 20), // Espacio reducido entre filas
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildActuatorTile(String label, bool isActive, Function(bool) onToggle) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
        Switch(
          value: isActive,
          onChanged: onToggle,
          activeColor: Colors.deepPurple,
          splashRadius: 24,
        ),
      ],
    );
  }

  Widget _buildSystemControlTile(String label, bool isOn) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
        Icon(
          isOn ? Icons.power : Icons.power_off,
          color: isOn ? Colors.green : Colors.red,
          size: 60,
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,  // Espaciado horizontal
        mainAxisSpacing: 5,   // Espaciado vertical
        childAspectRatio: 2.5,   // Relación de aspecto ajustada para hacer los botones más pequeños
        children: [
          _buildMenuButton(Icons.lightbulb, 'Luz', '/light'),
          _buildMenuButton(Icons.thermostat, 'Temperatura', '/temperature'),
          _buildMenuButton(Icons.water, 'Humedad', '/humidity'),
          _buildMenuButton(Icons.gas_meter_sharp, 'Gas', '/gas'),
          _buildMenuButton(Icons.punch_clock_sharp, 'Wearable', '/wearable'),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, String route) {
    bool isPressed = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
            Navigator.pushNamed(context, route);
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,  // Ajustamos el ancho de las tarjetas
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isPressed ? Colors.deepPurple : Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: isPressed
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                padding: const EdgeInsets.all(16.0), // Padding reducido
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // Alineación centrada
                  children: [
                    Icon(
                      icon,
                      size: 100, // Tamaño del ícono ajustado
                      color: isPressed ? Colors.white : Colors.deepPurple,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        color: isPressed ? Colors.white : Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
