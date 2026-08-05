import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/playa_modelo.dart';
import 'pantalla_lista_reportes.dart';

class PantallaMedusas extends StatefulWidget {
  const PantallaMedusas({super.key});

  @override
  State<PantallaMedusas> createState() => _PantallaMedusasState();
}

class _PantallaMedusasState extends State<PantallaMedusas> {
  String? playaIdSeleccionada;
  String nivelMedusas = 'Ninguna';

  final List<String> opcionesMedusas = ['Ninguna', 'Pocas', 'Bastantes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Medusas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // Botón en la AppBar para ir a la pantalla del listado histórico
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Ver Historial',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaListaReportes(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una playa de Málaga:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Desplegable de playas
            DropdownButtonFormField<String>(
              value: playaIdSeleccionada,
              hint: const Text('Elige una playa'),
              isExpanded: true,
              items: playasMalaga.map((PlayaModelo playa) {
                return DropdownMenuItem<String>(
                  value: playa.id,
                  child: Text(playa.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  playaIdSeleccionada = value;
                });
              },
            ),
            const SizedBox(height: 30),

            const Text(
              'Nivel de medusas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Opciones de medusas con ChoiceChip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: opcionesMedusas.map((opcion) {
                return ChoiceChip(
                  label: Text(opcion),
                  selected: nivelMedusas == opcion,
                  onSelected: (selected) {
                    setState(() {
                      nivelMedusas = opcion;
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),

            // Botón de guardar reporte
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: playaIdSeleccionada == null
                    ? null
                    : () async {
                        var box = Hive.box('configuracionBox');

                        final ahora = DateTime.now();
                        // Clave única basada en fecha, hora y minuto
                        final String claveUnica = 
                            'reporte_${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')}_${ahora.hour.toString().padLeft(2, '0')}-${ahora.minute.toString().padLeft(2, '0')}';

                        // Mapa con los datos estructurados
                        final Map<String, String> reporteData = {
                          'playa': playaIdSeleccionada!,
                          'nivel_medusas': nivelMedusas,
                          'fecha_hora': '${ahora.day}/${ahora.month}/${ahora.year} - ${ahora.hour}:${ahora.minute.toString().padLeft(2, '0')}',
                        };

                        // Guardamos codificado en JSON para que sea compatible y legible en Hive Web
                        await box.put(claveUnica, jsonEncode(reporteData));

                        final playaObj = playasMalaga.firstWhere(
                          (p) => p.id == playaIdSeleccionada,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Guardado: ${playaObj.nombre} ($nivelMedusas)',
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 80,
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                child: const Text(
                  'Guardar Reporte',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}