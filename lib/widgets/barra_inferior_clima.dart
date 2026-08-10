import 'package:flutter/material.dart';
import 'package:meteoflutter/screens/pantalla_grafica.dart';
import 'package:meteoflutter/screens/pantalla_medusas.dart';

class BarraInferiorClima extends StatelessWidget {
  final VoidCallback onVolverPressed;
  final VoidCallback? onFavoritosPressed;
  final VoidCallback? onActualizarPressed;

  final double latitud;
  final double longitud;
  final String nombreCiudad;

  const BarraInferiorClima({
    super.key,
    required this.onVolverPressed,
    this.onFavoritosPressed,
    this.onActualizarPressed,
    required this.latitud,
    required this.longitud,
    required this.nombreCiudad,
  });

  bool _esMalaga() {
    final ciudadLower = nombreCiudad.toLowerCase();
    return ciudadLower.contains('málaga') || ciudadLower.contains('malaga');
  }

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
            // Botón Gráfica
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.white),
              onPressed:
                  onFavoritosPressed ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaGrafica(
                          latitud: latitud,
                          longitud: longitud,
                          nombreCiudad: nombreCiudad,
                        ),
                      ),
                    );
                  },
              tooltip: 'Ver Gráfica',
            ),

            // Botón central: Volver atrás
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: onVolverPressed,
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Volver',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            // Botón derecho (Medusas) con validación de Málaga
            IconButton(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                if (_esMalaga()) {
                  if (onActualizarPressed != null) {
                    onActualizarPressed!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaMedusas(),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Los reportes de medusas solo están disponibles para Málaga.',
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 80,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              tooltip: 'Rango de Medusas',
            ),
          ],
        ),
      ),
    );
  }
}