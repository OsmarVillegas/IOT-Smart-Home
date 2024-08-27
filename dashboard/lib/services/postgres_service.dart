import 'package:postgres/postgres.dart';

class PostgresService {
  static final PostgresService _instance = PostgresService._internal();

  factory PostgresService() {
    return _instance;
  }

  PostgresService._internal()
    : connection = PostgreSQLConnection('host', 5432 , 'database', username: 'postgres', password: '');

  final PostgreSQLConnection connection;

  Future<void> connect() async {
    if (connection.isClosed) {
      try {
        await connection.open();
      } catch (e) {
        print('Error al conectar a PostgreSQL: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getHistoricalData(String tableName) async {
    List<Map<String, dynamic>> results = [];

    try {
      var data = await connection.query(
        'SELECT created_at, value FROM $tableName ORDER BY created_at DESC LIMIT 24',
        allowReuse: false, 
      );
      results = data.map((row) {
        return {
          'time': row[0],
          'value': row[1],
        };
      }).toList();
    } catch (e) {
      print('Error al obtener datos históricos: $e');
    }

    return results;
  }

  Future<Map<String, double?>> getMinMaxValues(String tableName) async {
  Map<String, double?> result = {'min': null, 'max': null};

  try {
    var data = await connection.query(
      'SELECT MIN(value), MAX(value) FROM $tableName',
      allowReuse: false, 
    );
    if (data.isNotEmpty) {
      result['min'] = (data[0][0] != null) ? double.tryParse(data[0][0].toString()) : null;
      result['max'] = (data[0][1] != null) ? double.tryParse(data[0][1].toString()) : null;
    }
  } catch (e) {
    print('Error al obtener los valores min/max: $e');
  }

  return result;
}

  Future<void> close() async {
    await connection.close();
  }
}
