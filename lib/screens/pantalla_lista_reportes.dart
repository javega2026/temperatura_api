import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PantallaListaReportes extends StatelessWidget {
  const PantallaListaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('configuracionBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Reportes'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          final keys = box.keys
              .where((key) => key.toString().startsWith('reporte_'))
              .toList();

          if (keys.isEmpty) {
            return const Center(
              child: Text(
                'No hay reportes guardados todavía.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final rawData = box.get(key);
              
              Map<String, dynamic> datos = {};

              if (rawData is String) {
                datos = Map<String, dynamic>.from(jsonDecode(rawData));
              } else if (rawData is Map) {
                datos = Map<String, dynamic>.from(rawData);
              }

              final nivel = datos['nivel_medusas']?.toString() ?? '';

              Color cardBackgroundColor;
              Color iconColor;

              if (nivel == 'Bastantes' || nivel == 'Muchas') {
                cardBackgroundColor = Colors.red.shade300;
                iconColor = Colors.black;
              } else if (nivel == 'Moderadas' || nivel == 'Pocas') {
                cardBackgroundColor = Colors.orange.shade200;
                iconColor = Colors.black;
              } else {
                cardBackgroundColor = Colors.green.shade200;
                iconColor = Colors.black;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                color: cardBackgroundColor,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: iconColor.withValues(alpha: 0.2),
                    child: Icon(Icons.beach_access, color: iconColor),
                  ),
                  title: Text(
                    'Playa ID: ${datos['playa'] ?? 'Desconocida'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Letras en negro
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Nivel de medusas: $nivel',
                      style: const TextStyle(
                        color: Colors.black, // Letras en negro
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  trailing: Text(
                    datos['fecha_hora']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 17, 
                      color: Colors.black, // Letras en negro
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}