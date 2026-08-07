import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/playa_modelo.dart';
import 'pantalla_lista_reportes.dart';
import 'pantalla_ia.dart'; // <-- Añadimos la importación de la pantalla de IA

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
    final box = Hive.box('configuracionBox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, _) {
        final keys = box.keys
            .where((key) => key.toString().startsWith('reporte_'))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Reporte de Medusas'),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            actions: [
              // --- NUEVO BOTÓN DE LA IA ---
              IconButton(
                icon: const Icon(Icons.auto_awesome, size: 28, color: Colors.white),
                tooltip: 'Análisis de medusas con IA',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaIa(),
                    ),
                  );
                },
              ),
              // -----------------------------
              
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaListaReportes(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list, color: Colors.white),
                  label: Text(
                    '${keys.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                            final ahora = DateTime.now();
                            final String claveUnica = 
                                'reporte_${ahora.millisecondsSinceEpoch}';

                            final Map<String, String> reporteData = {
                              'playa': playaIdSeleccionada!,
                              'nivel_medusas': nivelMedusas,
                              'fecha_hora': '${ahora.day}/${ahora.month}/${ahora.year} - ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}',
                            };

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
      },
    );
  }
}