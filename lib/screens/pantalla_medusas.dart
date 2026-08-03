import 'package:flutter/material.dart';

// Pantalla para mostrar el rango/estado de medusas
class PantallaMedusas extends StatelessWidget {
  const PantallaMedusas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rango de Medusas en Playas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Aquí irá el estado y reporte de medusas',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}