import 'package:flutter/material.dart';

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
            // Botón izquierdo (Favoritos)
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: onFavoritosPressed ?? () {},
              tooltip: 'Favoritos',
              
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

            // Botón derecho (Actualizar)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: onActualizarPressed ?? () {},
              tooltip: 'Actualizar',
            ),
          ],
        ),
      ),
    );
  }
}