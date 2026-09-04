import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/widgets/tarjeta_clima_principal.dart';
import 'package:meteoflutter/widgets/barra_inferior_clima.dart';

import 'widgets_temperatura_dinamica.dart';

class TemperaturaPantallaDinamica extends StatelessWidget {
  final ClimaModelo1 clima;

  const TemperaturaPantallaDinamica({super.key, required this.clima});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en ${clima.nombreCiudad}'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BarraInferiorClima(
        onVolverPressed: () {
          Navigator.pop(context);
        },
        latitud: clima.lat,
        longitud: clima.lon,
        nombreCiudad: clima.nombreCiudad,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TarjetaClimaPrincipal(clima: clima),
            const SizedBox(height: 20),
            WidgetsTemperaturaDinamica(clima: clima),
          ],
        ),
      ),
    );
  }
}