import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaPruebas extends StatelessWidget {
  const PantallaPruebas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Pruebas Firebase'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Guardar Prueba en Firebase'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onPressed: () async {
              // 1. Preparamos los datos de prueba
              final datosPrueba = {
                'temperatura': '22ºC',
                'humedad': '60%',
                'fecha': DateTime.now().toString(),
              };

              try {
                // 2. Enviamos los datos usando la línea que analizamos
                await FirebaseFirestore.instance
                    .collection('pruebas')
                    .add(datosPrueba);

                // 3. Mostramos un aviso de éxito en pantalla
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Datos guardados con éxito en Firebase!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                // Si ocurre algún error, lo mostramos
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}