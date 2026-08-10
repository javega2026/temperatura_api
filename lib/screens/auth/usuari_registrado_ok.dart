import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioRegistradoOk extends StatelessWidget {
  const UsuarioRegistradoOk({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario actual conectado en Firebase
    final usuario = FirebaseAuth.instance.currentUser;
    final emailUsuario = usuario?.email ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área de Usuario'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                '¡Registro y Acceso OK!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Bienvenido,\n$emailUsuario',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
            
            
            
             SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red[700],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () async {
      // Cerramos sesión en Firebase
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      // Volvemos a la pantalla anterior
      Navigator.pop(context);
    },
    child: const Text(
      'Cerrar Sesión',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
),





            ],
          ),
        ),
      ),
    );
  }
}