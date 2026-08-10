import 'package:flutter/material.dart';
import '../servicios/ia_servicio.dart';

class PantallaIa extends StatelessWidget {
  const PantallaIa({super.key});

  @override
  Widget build(BuildContext context) {
    final iaServicio = IaServicio();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de Medusas - IA'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<String>(
          future: iaServicio.obtenerAnalisisMedusas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('La IA está analizando los reportes de Málaga...'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(
                child: Text(
                  snapshot.data ?? 'Sin datos',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}