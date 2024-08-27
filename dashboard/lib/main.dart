import 'package:dashboard/screens/wearable_screen.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/temperature_screen.dart';
import 'screens/humidity_screen.dart';
import 'screens/light_screen.dart';
import 'screens/gas_screen.dart';
import 'services/mqtt_service.dart';
import 'services/postgres_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Conectar a PostgreSQL
  await PostgresService().connect();

  // Conectar a MQTT (sin suscribirse a tópicos aún)
  await MqttService().connect([], (_) {});

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/temperature': (context) => const TemperatureScreen(),
        '/humidity': (context) => const HumidityScreen(),
        '/light': (context) => const LightScreen(),
        '/gas': (context) => const GasScreen(),
        '/wearable': (context) => const WearableScreen(),
      },
    );
  }
}
