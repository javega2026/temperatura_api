import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/models/playa_modelo1.dart';
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';
import 'package:meteoflutter/models/provincia_costera.dart';

import 'package:meteoflutter/vistas/pantalla_ia/pantalla_ia.dart';
import 'package:meteoflutter/vistas/lista_reportes_medusas/widget_selector_playa.dart';
import 'package:meteoflutter/vistas/lista_reportes_medusas/widget_selector_medusa.dart';
import 'package:meteoflutter/widgets/responsive_body.dart';
import 'widgets_formulario_medusas_pantalla.dart';
import 'botones_formulario_medusas.dart';

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

  bool get _esProvinciaCostera {
    final ciudad = widget.ciudadInicial.toLowerCase().trim();

    return provinciasCosterasEspana.any((p) {
      final nombrePrincipal = p.nombre.toLowerCase();
      
      if (ciudad.contains(nombrePrincipal) || nombrePrincipal.contains(ciudad)) {
        return true;
      }

      return p.alias.any((alias) {
        final a = alias.toLowerCase();
        return ciudad.contains(a) || a.contains(ciudad);
      });
    });
  }

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
    final bool puedeGuardar = playaIdSeleccionada != null && medusaIdSeleccionada != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Reporte de Medusas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          if (_esProvinciaCostera)
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                shape: const CircleBorder(),
              ),
              icon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.amberAccent,
                    Colors.pinkAccent,
                    Colors.cyanAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              tooltip: 'Consultar Informe IA',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaIa(ciudad: widget.ciudadInicial),
                  ),
                );
              },
            ),
          const BotonContadorReportes(),
        ],
      ),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
                WidgetSelectorNivelMedusas(
                  nivelSeleccionado: nivelMedusas,
                  opciones: opcionesMedusas,
                  onNivelChanged: (nuevoNivel) {
                    setState(() {
                      nivelMedusas = nuevoNivel;
                    });
                  },
                ),
                BotonesFormularioMedusas(
                  puedeGuardar: puedeGuardar,
                  onGuardar: _guardarReporte,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}