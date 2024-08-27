import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';
import '../services/postgres_service.dart';
import '../widgets/gauge_widget.dart';
import '../widgets/historical_table.dart';
import '../widgets/card_maxmin_widget.dart';
import '../models/sensor_data.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  double _luz = 0.0;
  List<Map<String, dynamic>> _historicalData = [];
  double? _minValue;
  double? _maxValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadHistoricalData();

    MqttService().connect(['project/luz/data'], _onDataReceived);
  }

  Future<void> _loadHistoricalData() async {
    List<Map<String, dynamic>> data = await PostgresService().getHistoricalData('photoresistor_historic');
    Map<String, double?> minMaxValues = await PostgresService().getMinMaxValues('photoresistor_historic');

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
  if (data.type == 'luz') {
    setState(() {
      if (data.value is double) {
        _luz = data.value;
      } else if (data.value is int) {
        _luz = (data.value as int).toDouble();
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luz'),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GaugeWidget(
                      title: 'Valor de Luz',
                      value: _luz,
                      minValue: 0,
                      maxValue: 1050,
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
              child: HistoricalTable(data: _historicalData, title: 'Histórico de Luz'),
            ),
          ],
        ),
      ),
    );
  }
}
