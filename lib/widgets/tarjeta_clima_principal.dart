import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';

class TarjetaClimaPrincipal extends StatelessWidget {
  final ClimaModelo1 clima;

  const TarjetaClimaPrincipal({super.key, required this.clima});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // El mapa dinámico por coordenadas
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
    );
  }
}