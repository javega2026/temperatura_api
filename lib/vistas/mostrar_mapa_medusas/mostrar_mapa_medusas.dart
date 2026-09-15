import 'package:flutter/material.dart';
// Import absoluto
import 'package:meteoflutter/widgets/responsive_body.dart';

class MostrarMapaMedusas extends StatefulWidget {
  const MostrarMapaMedusas({super.key});

  @override
  State<MostrarMapaMedusas> createState() => _MostrarMapaMedusasState();
}

class _MostrarMapaMedusasState extends State<MostrarMapaMedusas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Medusas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avistamientos en Mapa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta la ubicación de las medusas reportadas por los usuarios.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // Contenedor temporal tipo "Placeholder" para el mapa
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 64,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Aquí se cargará el mapa interactivo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}