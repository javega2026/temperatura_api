import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';

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
        // El botón de atrás aparece aquí de forma automática al usar Navigator.push
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tarjeta principal con el Mapa de Coordenadas y la Temperatura
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // --- MAPA DINÁMICO POR COORDENADAS ---
                  Image.network(
                    'https://static-maps.yandex.ru/1.x/?ll=${clima.lon},${clima.lat}&size=600,200&z=10&l=map&pt=${clima.lon},${clima.lat},pm2rdm',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.blue[50],
                      child: const Center(
                        child: Icon(Icons.map, size: 50, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          clima.nombreCiudad,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${clima.temperatura.toStringAsFixed(1)} °C',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Sensación térmica: ${clima.sensTermica.toStringAsFixed(1)} °C',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                _buildTarjetasDetalle(
                  'Sensación Térmica', 
                  '${clima.sensTermica.toStringAsFixed(1)} °C', 
                  Icons.thermostat
                ),
                _buildTarjetasDetalle(
                  'Humedad', 
                  '${clima.humedad} %', 
                  Icons.water_drop
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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