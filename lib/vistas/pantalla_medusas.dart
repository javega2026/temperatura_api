import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pantalla_lista_reportes.dart';
import 'pantalla_ia.dart';
import 'package:meteoflutter/models/playa_modelo1.dart'; 
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';
import '/widgets/usuario_guarda_medusa/widget_selector_playa.dart';
import '/widgets/usuario_guarda_medusa/widget_selector_medusa.dart';

class PantallaMedusas extends StatefulWidget {
  const PantallaMedusas({super.key});

  @override
  State<PantallaMedusas> createState() => _PantallaMedusasState();
}

class _PantallaMedusasState extends State<PantallaMedusas> {
  String? playaIdSeleccionada;
  String? nombrePlayaSeleccionada;
  double? latitudPlayaSeleccionada;  // 📍 Variable para la latitud
  double? longitudPlayaSeleccionada; // 📍 Variable para la longitud

  String? medusaIdSeleccionada;
  String? nombreMedusaSeleccionada;
  String? nombreEspecificoMedusa;
  String? imagenMedusaUrl;

  String nivelMedusas = '1 - 5';
  final List<String> opcionesMedusas = ['1 - 5', '6 - 15', 'Más de 15'];

  // 🚀 Lógica de guardado incluyendo latitud y longitud
  Future<void> _guardarReporte() async {
    final ahora = DateTime.now();
    final formatoFecha = '${ahora.day}/${ahora.month}/${ahora.year} - ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}';

    // Obtenemos el objeto completo de la playa elegida en el modelo de Andalucía
    final playaSeleccionadaObj = playasAndalucia.firstWhere((p) => p.id == playaIdSeleccionada);

    final nuevoReporte = ReporteMedusaModelo(
      nombreComun: nombreMedusaSeleccionada ?? 'Desconocida',
      nombreEspecifico: nombreEspecificoMedusa ?? 'Sin especificar',
      imagen: imagenMedusaUrl ?? '',
      playa: nombrePlayaSeleccionada ?? 'Desconocida',
      provincia: playaSeleccionadaObj.provincia,
      nivelMedusas: nivelMedusas,
      fechaHora: formatoFecha,
      latitud: latitudPlayaSeleccionada ?? playaSeleccionadaObj.latitud,   // 📍 Guardamos latitud
      longitud: longitudPlayaSeleccionada ?? playaSeleccionadaObj.longitud, // 📍 Guardamos longitud
    );

    try {
      await FirebaseFirestore.instance
          .collection('reportes_medusas')
          .add(nuevoReporte.toMap());

      // Limpiar formulario por completo
      setState(() {
        playaIdSeleccionada = null;
        nombrePlayaSeleccionada = null;
        latitudPlayaSeleccionada = null;
        longitudPlayaSeleccionada = null;
        medusaIdSeleccionada = null;
        nombreMedusaSeleccionada = null;
        nombreEspecificoMedusa = null;
        imagenMedusaUrl = null;
        nivelMedusas = '1 - 5';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reporte con coordenadas guardado en Firebase con éxito! 🌊'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Medusas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // Botón de IA
          IconButton(
            icon: const Icon(Icons.auto_awesome, size: 28, color: Colors.white),
            tooltip: 'IA',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaIa()),
              );
            },
          ),
          // Botón de Lista con contador en tiempo real
          const _BotonContadorReportes(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Selector de Playa (Adaptado para recibir el objeto PlayaModelo desde el widget)
            WidgetSelectorPlaya(
              playaIdSeleccionada: playaIdSeleccionada,
              onPlayaSelected: (PlayaModelo? playa) {
                setState(() {
                  if (playa != null) {
                    playaIdSeleccionada = playa.id;
                    nombrePlayaSeleccionada = playa.nombre;
                    latitudPlayaSeleccionada = playa.latitud;   // 📍 Capturamos latitud
                    longitudPlayaSeleccionada = playa.longitud; // 📍 Capturamos longitud
                  } else {
                    playaIdSeleccionada = null;
                    nombrePlayaSeleccionada = null;
                    latitudPlayaSeleccionada = null;
                    longitudPlayaSeleccionada = null;
                  }
                });
              },
            ),

            const SizedBox(height: 25),

            // 2. Selector de Medusa
            WidgetSelectorMedusa(
              medusaIdSeleccionada: medusaIdSeleccionada,
              onMedusaSelected: (value) async {
                setState(() {
                  medusaIdSeleccionada = value;
                });
                if (value != null) {
                  final doc = await FirebaseFirestore.instance
                      .collection('datos_medusas')
                      .doc(value)
                      .get();
                  if (doc.exists) {
                    final data = doc.data() as Map<String, dynamic>;
                    setState(() {
                      nombreMedusaSeleccionada = data['nombre'] ?? '';
                      nombreEspecificoMedusa = data['nombreCientifico'] ?? data['nombre_cientifico'] ?? '';
                      imagenMedusaUrl = data['url'] ?? '';
                    });
                  }
                } else {
                  setState(() {
                    nombreMedusaSeleccionada = null;
                    nombreEspecificoMedusa = null;
                    imagenMedusaUrl = null;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            // 3. Sección Nivel de Medusas
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

            // 4. Botón Guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (medusaIdSeleccionada == null || playaIdSeleccionada == null)
                    ? null
                    : _guardarReporte,
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

// 🧩 Widget privado auxiliar para la AppBar
class _BotonContadorReportes extends StatelessWidget {
  const _BotonContadorReportes();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reportes_medusas').snapshots(),
      builder: (context, snapshot) {
        int totalReportes = 0;
        if (snapshot.hasData) {
          totalReportes = snapshot.data!.docs.length;
        }

        return Padding(
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
              '$totalReportes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}