import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';
import '../services/postgres_service.dart';
import '../widgets/gauge_widget.dart';
import '../widgets/historical_table.dart';
import '../models/sensor_data.dart';
import '../widgets/card_maxmin_widget.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  double _temperature = 0.0;
  List<Map<String, dynamic>> _historicalData = [];
  double? _minValue;
  double? _maxValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Conectarse a la base de datos PostgreSQL y cargar los datos históricos
    _loadHistoricalData();

    // Conectarse al tópico MQTT
    MqttService().connect(['project/temperatura/data'], _onDataReceived);
  }

  Future<void> _loadHistoricalData() async {
    List<Map<String, dynamic>> data = await PostgresService().getHistoricalData('temperature_historic');
    Map<String, double?> minMaxValues = await PostgresService().getMinMaxValues('temperature_historic');

    data = data.map((entry) {
      var value = entry['value'];
      double? numericValue = double.tryParse(value.toString());
      return {
        'time': entry['time'],
        'value': numericValue != null ? double.parse(numericValue.toStringAsFixed(2)) : value,
      };
    }).toList();

    setState(() {
      _historicalData = data;
      _minValue = minMaxValues['min'];
      _maxValue = minMaxValues['max'];
    });
  }

  void _onDataReceived(SensorData data) {
    if (data.type == 'temperatura') {
      setState(() {
        if (data.value is double) {
        _temperature = data.value;
      } else if (data.value is int) {
        _temperature = (data.value as int).toDouble();
      }
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperatura'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
                  children: [
                    GaugeWidget(
                      title: 'Valor de Temperatura',
                      value: _temperature,
                      minValue: 0,
                      maxValue: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    ValueCard(
                      label: 'Valor Mínimo Registrado',
                      value: _minValue,
                    ),
                    ValueCard(
                      label: 'Valor Máximo Registrado',
                      value: _maxValue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: HistoricalTable(data: _historicalData, title: 'Histórico de Temperatura'),
            ),
          ],
        ),
      ),
    );
  }
}
