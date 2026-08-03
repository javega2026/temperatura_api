import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/widgets/tarjeta_clima_principal.dart';
import 'package:meteoflutter/widgets/tarjeta_detalle_clima.dart';
import 'package:meteoflutter/widgets/barra_inferior_clima.dart'; 

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
      // --- USAMOS EL WIDGET EXTERNO DE LA BARRA INFERIOR ---
      bottomNavigationBar: BarraInferiorClima(
        onVolverPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tarjeta principal con el mapa y la temperatura
            TarjetaClimaPrincipal(clima: clima),
            const SizedBox(height: 20),

            // Detalles en cuadrícula (Sensación térmica y Humedad)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                TarjetaDetalleClima(
                  titulo: 'Sensación Térmica',
                  valor: '${clima.sensTermica.toStringAsFixed(1)} °C',
                  icono: Icons.thermostat,
                ),
                TarjetaDetalleClima(
                  titulo: 'Humedad',
                  valor: '${clima.humedad} %',
                  icono: Icons.water_drop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}