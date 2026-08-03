import 'package:flutter/material.dart';
import '../screens/pantalla_grafica.dart';
import '../screens/pantalla_medusas.dart';
import '../screens/ejemplo_datos_grafica.dart';

class BarraInferiorClima extends StatelessWidget {
  final VoidCallback onVolverPressed;
  final VoidCallback? onFavoritosPressed;
  final VoidCallback? onActualizarPressed;

  const BarraInferiorClima({
    super.key,
    required this.onVolverPressed,
    this.onFavoritosPressed,
    this.onActualizarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueAccent,
      child: Container(
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Botón izquierdo (Gráfica)
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.white),
              onPressed: onFavoritosPressed ?? () {
                Navigator.push(
                  context,
                 // MaterialPageRoute(builder: (context) => const PantallaGrafica()),
                   MaterialPageRoute(builder: (context) => const TemperaturaGraficoWidget()),


                  
                );
              },
              tooltip: 'Ver Gráfica',
            ),

            // Botón central: Volver atrás
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: onVolverPressed,
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Volver',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            // Botón derecho (Medusas)
            IconButton(
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
              onPressed: onActualizarPressed ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaMedusas()),
                );
              },
              tooltip: 'Rango de Medusas',
            ),
          ],
        ),
      ),
    );
  }
}