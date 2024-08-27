import 'package:flutter/material.dart';

class HistoricalTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;

  const HistoricalTable({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8), // Espacio entre el título y la lista
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final entry = data[index];
              return Card(
                color: Colors.deepPurple.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(
                    '${entry['value'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    '${entry['time']}',
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
