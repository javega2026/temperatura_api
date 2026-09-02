import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaListaReportes extends StatelessWidget {
  const PantallaListaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reportes'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Cambiamos a la colección donde los usuarios guardan los reportes
        stream: FirebaseFirestore.instance
            .collection('reportes_medusas')
            .orderBy('fecha_hora', descending: true) // Opcional: ordenados por fecha
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay reportes de medusas todavía.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              
              final nombreComun = data['nombre_comun'] ?? 'Desconocida';
              final nombreEspecifico = data['nombre_especifico'] ?? '';
              final playa = data['playa'] ?? 'Playa desconocida';
              final nivel = data['nivel_medusas'] ?? 'N/A';
              final fecha = data['fecha_hora'] ?? '';
              final imagenUrl = data['imagen'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // Mostramos la imagen de la medusa si existe la URL
                    leading: imagenUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imagenUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : const Icon(Icons.warning, size: 40, color: Colors.orange),
                    
                    title: Text(
                      '$nombreComun ($nombreEspecifico)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('🏖️ Playa: $playa'),
                        Text('📊 Nivel: $nivel'),
                        Text('📅 Fecha: $fecha', style: const TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}