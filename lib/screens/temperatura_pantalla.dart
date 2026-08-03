import 'package:flutter/material.dart';

class TemperaturaPantalla extends StatelessWidget {
  const TemperaturaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados basados en el JSON de Sevilla que revisamos
    final String ciudad = "Seville";
    final String pais = "ES";
    final double temp = 22.59;
    final double sensTermica = 22.94;
    final double tempMin = 21.84;
    final double tempMax = 23.33;
    final String descripcion = "Cubes cubiertas / Nublado denso";
    final int humedad = 78;
    final double viento = 1.79;
    final int presion = 1013;

    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en $ciudad ($pais)'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tarjeta principal de Temperatura
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${temp.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Sensación térmica: ${sensTermica.toStringAsFixed(1)} °C',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detalles en cuadrícula (Mínima, Máxima, Humedad, etc.)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _buildTarjetasDetalle(
                  'Mín / Máx', 
                  '${tempMin.toStringAsFixed(1)}° / ${tempMax.toStringAsFixed(1)}°', 
                  Icons.thermostat
                ),
                _buildTarjetasDetalle(
                  'Humedad', 
                  '$humedad %', 
                  Icons.water_drop
                ),
                _buildTarjetasDetalle(
                  'Viento', 
                  '$viento m/s', 
                  Icons.air
                ),
                _buildTarjetasDetalle(
                  'Presión', 
                  '$presion hPa', 
                  Icons.speed
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las tarjetas pequeñas de detalles
  Widget _buildTarjetasDetalle(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}