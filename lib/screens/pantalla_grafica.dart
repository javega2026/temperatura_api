import 'package:flutter/material.dart';
// Pantalla para mostrar la gráfica de temperaturas
class PantallaGrafica extends StatelessWidget {
  const PantallaGrafica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Temperaturas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Aquí irá la gráfica de los últimos días',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

