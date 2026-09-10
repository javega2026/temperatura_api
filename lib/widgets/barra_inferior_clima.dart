import 'package:flutter/material.dart';
import 'package:meteoflutter/vistas/pantalla_grafica/pantalla_grafica.dart';
import 'package:meteoflutter/vistas/formulario_medusas_pantalla/formulario_medusas_pantalla.dart';

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

            // Botón derecho (Medusas) libre de restricciones
            IconButton(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                debugPrint('--------------------------------------------------');
                debugPrint('📍 [LOG 1 - BARRA INFERIOR] Navegando a Formulario');
                debugPrint('   -> Ciudad transmitida: "$nombreCiudad"');
                debugPrint('--------------------------------------------------');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormularioMedusasPantalla(
                      ciudadInicial: nombreCiudad,
                    ),
                  ),
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