import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/widgets/tarjeta_detalle_clima.dart';

// Widget para la cuadrícula de detalles (Sensación, Humedad, Viento, Presión)
class WidgetsTemperaturaDinamica extends StatelessWidget {
  final ClimaModelo1 clima;

  const WidgetsTemperaturaDinamica({super.key, required this.clima});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.7,
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
        TarjetaDetalleClima(
          titulo: 'Viento',
          valor: '${clima.vientoVelocidad} km/h',
          icono: Icons.air,
        ),
        TarjetaDetalleClima(
          titulo: 'Presión',
          valor: '${clima.presion} hPa',
          icono: Icons.speed,
        ),
      ],
    );
  }
}