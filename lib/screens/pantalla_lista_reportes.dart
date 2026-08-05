import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // Importamos la librería intl

class PantallaListaReportes extends StatelessWidget {
  const PantallaListaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('configuracionBox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, _) {
        final ahora = DateTime.now();

        // Definimos el formato en el que guardamos las fechas
        final formatoFecha = DateFormat('d/M/yyyy - HH:mm');

        // Filtrar y eliminar automáticamente los reportes con más de 1 hora de antigüedad
        final keys = box.keys
            .where((key) => key.toString().startsWith('reporte_'))
            .toList();

        for (var key in keys) {
          final rawData = box.get(key);
          if (rawData != null) {
            try {
              final data = jsonDecode(rawData);
              final String? fechaHoraStr = data['fecha_hora'];

              if (fechaHoraStr != null) {
                // Parseamos la fecha de forma limpia con intl
                final DateTime fechaReporte = formatoFecha.parse(fechaHoraStr);

                // Si ha pasado 1 hora o más, se borra de Hive (puedes cambiar a .inDays >= 1 si prefieres un día)
                if (ahora.difference(fechaReporte).inHours >= 1) {
                  box.delete(key);
                }

                // if (ahora.difference(fechaReporte).inDays >= 1) {
                //   box.delete(key);
                // }
              }
            } catch (_) {
              // Si falla el parseo de alguna clave antigua, se ignora o limpia
            }
          }
        }

        // Volver a obtener las keys actualizadas después de la limpieza
        final keysValidas = box.keys
            .where((key) => key.toString().startsWith('reporte_'))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Historial de Reportes (${keysValidas.length})'),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          body: keysValidas.isEmpty
              ? const Center(
                  child: Text(
                    'No hay reportes recientes (se eliminan tras 1 hora).',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: keysValidas.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final key = keysValidas[index];
                    final rawData = box.get(key);
                    if (rawData == null) return const SizedBox.shrink();

                    final Map<String, dynamic> data = jsonDecode(rawData);
                    final String playa = data['playa'] ?? '';
                    final String nivel = data['nivel_medusas'] ?? 'Ninguna';
                    final String fechaHora = data['fecha_hora'] ?? '';

                    Color colorFondo;
                    if (nivel == 'Bastantes') {
                      colorFondo = Colors.red[300]!;
                    } else if (nivel == 'Pocas') {
                      colorFondo = Colors.orange[300]!;
                    } else {
                      colorFondo = Colors.green[300]!;
                    }

                    return Card(
                      color: colorFondo,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.black26,
                          child: Icon(
                            Icons.beach_access,
                            color: Colors.black87,
                          ),
                        ),
                        title: Text(
                          'Playa ID: $playa',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Nivel de medusas: $nivel',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          fechaHora,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
