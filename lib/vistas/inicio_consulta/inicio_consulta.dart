import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meteoflutter/servicios/clima_servicio1.dart';
import 'package:meteoflutter/vistas/temperatura_dinamica/temperatura_pantalla_dinamica.dart';

import 'widgets_inicio_consulta.dart';

class InicioConsulta extends StatefulWidget {
  const InicioConsulta({super.key});

  @override
  State<InicioConsulta> createState() => _InicioConsultaState();
}

class _InicioConsultaState extends State<InicioConsulta> {
  final TextEditingController _controladorCiudad = TextEditingController();
  final ClimaServicio1 _climaServicio = ClimaServicio1();
  bool _cargando = false;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _controladorCiudad.text = 'Málaga';

    FirebaseAnalytics.instance.setUserProperty(
      name: "debug_mode",
      value: "true",
    );
    FirebaseAnalytics.instance.logEvent(
      name: "pantalla_principal_abierta",
      parameters: {"origen": "inicio_consulta"},
    );
  }

  void _buscarClima() async {
    final ciudad = _controladorCiudad.text.trim();
    if (ciudad.isEmpty) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final resultado = await _climaServicio.obtenerClimaPorCiudad(ciudad);

    setState(() {
      _cargando = false;
    });

    if (resultado != null) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TemperaturaPantallaDinamica(clima: resultado),
        ),
      );
    } else {
      setState(() {
        _mensajeError = 'No se encontraron datos para "$ciudad"';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Clima'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wb_sunny_rounded,
                size: 80,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                '¿Qué tiempo hace hoy?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 30),
              CampoCiudad(
                controller: _controladorCiudad,
                onSubmitted: _buscarClima,
              ),
              const SizedBox(height: 20),
              BotonesConsulta(
                cargando: _cargando,
                onBuscar: _buscarClima,
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 20),
                Text(
                  _mensajeError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}