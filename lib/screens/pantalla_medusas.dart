import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/playa_modelo.dart';

class PantallaMedusas extends StatefulWidget {
  const PantallaMedusas({super.key});

  @override
  State<PantallaMedusas> createState() => _PantallaMedusasState();
}

class _PantallaMedusasState extends State<PantallaMedusas> {
  // Variable para almacenar el id de la playa seleccionada
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

            // Desplegable de playas usando tu lista 'playasMalaga'
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

            // Opciones de medusas con chips
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

            // Botón de guardar con Hive
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: playaIdSeleccionada == null
                    ? null
                    : () async {
                        // Guardar en la caja de Hive que abrimos en el main
                        var box = Hive.box('configuracionBox');
                        await box.put(
                          'playa_seleccionada_id',
                          playaIdSeleccionada,
                        );
                        await box.put('nivel_medusas', nivelMedusas);

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
                              behavior: SnackBarBehavior
                                  .floating, // <-- Esto lo despega del fondo y lo sube
                              margin: const EdgeInsets.only(left: 16,right: 16,bottom: 80
                              ), // <-- Margen para que flote elegante
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
