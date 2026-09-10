import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/models/playa_modelo1.dart';
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';

import 'package:meteoflutter/vistas/pantalla_ia/pantalla_ia.dart';

import 'package:meteoflutter/vistas/lista_reportes_medusas/widget_selector_playa.dart';
import 'package:meteoflutter/vistas/lista_reportes_medusas/widget_selector_medusa.dart';

import 'widgets_formulario_medusas_pantalla.dart';

class FormularioMedusasPantalla extends StatefulWidget {
  final String ciudadInicial;

  const FormularioMedusasPantalla({
    super.key,
    required this.ciudadInicial,
  });

  @override
  State<FormularioMedusasPantalla> createState() => _FormularioMedusasPantallaState();
}

class _FormularioMedusasPantallaState extends State<FormularioMedusasPantalla> {
  String? playaIdSeleccionada;
  String? nombrePlayaSeleccionada;
  double? latitudPlayaSeleccionada;
  double? longitudPlayaSeleccionada;

  String? medusaIdSeleccionada;
  String? nombreMedusaSeleccionada;
  String? nombreEspecificoMedusa;
  String? imagenMedusaUrl;

  String nivelMedusas = '1 - 5';
  final List<String> opcionesMedusas = ['1 - 5', '6 - 15', 'Más de 15'];

  Key _keyPlaya = UniqueKey();
  Key _keyMedusa = UniqueKey();

  Future<void> _guardarReporte() async {
    final ahora = DateTime.now();
    final formatoFecha = '${ahora.day.toString().padLeft(2, '0')}/${ahora.month.toString().padLeft(2, '0')}/${ahora.year} - ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}';

    final playaSeleccionadaObj = playasAndalucia.firstWhere((p) => p.id == playaIdSeleccionada);

    final nuevoReporte = ReporteMedusaModelo(
      nombreComun: nombreMedusaSeleccionada ?? 'Desconocida',
      nombreEspecifico: nombreEspecificoMedusa ?? 'Sin especificar',
      imagen: imagenMedusaUrl ?? '',
      playa: nombrePlayaSeleccionada ?? 'Desconocida',
      provincia: playaSeleccionadaObj.provincia,
      nivelMedusas: nivelMedusas,
      fechaHora: formatoFecha,
      latitud: latitudPlayaSeleccionada ?? playaSeleccionadaObj.latitud,
      longitud: longitudPlayaSeleccionada ?? playaSeleccionadaObj.longitud,
    );

    try {
      final datosAInsertar = nuevoReporte.toMap();
      datosAInsertar['timestamp'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('reportes_medusas')
          .add(datosAInsertar);

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

        _keyPlaya = UniqueKey();
        _keyMedusa = UniqueKey();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reporte guardado con éxito! 🌊'),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Reporte de Medusas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              final ciudad = widget.ciudadInicial;

              debugPrint('--------------------------------------------------');
              debugPrint('🤖 [LOG 2 - FORMULARIO] Pulsado botón IA');
              debugPrint('   -> Ciudad enviada a PantallaIa: "$ciudad"');
              debugPrint('--------------------------------------------------');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaIa(ciudad: ciudad),
                ),
              );
            },
          ),
          const BotonContadorReportes(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetSelectorPlaya(
                  key: _keyPlaya,
                  playaIdSeleccionada: playaIdSeleccionada,
                  onPlayaSelected: (PlayaModelo? playa) {
                    setState(() {
                      if (playa != null) {
                        playaIdSeleccionada = playa.id;
                        nombrePlayaSeleccionada = playa.nombre;
                        latitudPlayaSeleccionada = playa.latitud;
                        longitudPlayaSeleccionada = playa.longitud;
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

                WidgetSelectorMedusa(
                  key: _keyMedusa,
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

                WidgetSelectorNivelMedusas(
                  nivelSeleccionado: nivelMedusas,
                  opciones: opcionesMedusas,
                  onNivelChanged: (nuevoNivel) {
                    nivelMedusas = nuevoNivel;
                  },
                ),
              ],
            ),

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