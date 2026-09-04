import 'package:flutter/material.dart';

import 'package:meteoflutter/vistas/auth/login_screen.dart';

// Campo para escribir la ciudad/provincia
class CampoCiudad extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const CampoCiudad({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Escribe una provincia (ej. Sevilla)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onSubmitted: (_) => onSubmitted(),
    );
  }
}

// Botones de la pantalla
class BotonesConsulta extends StatelessWidget {
  final bool cargando;
  final VoidCallback onBuscar;

  const BotonesConsulta({
    super.key,
    required this.cargando,
    required this.onBuscar,
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: cargando ? null : onBuscar,
            child: cargando
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Consultar Clima',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 32),
      
      
        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.indigo,
              side: BorderSide(color: Colors.indigo.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.login),
            label: const Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}