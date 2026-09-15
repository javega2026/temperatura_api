import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WidgetSelectorMedusa extends StatelessWidget {
  final String? medusaIdSeleccionada;
  final ValueChanged<String?> onMedusaSelected;

  const WidgetSelectorMedusa({
    super.key,
    required this.medusaIdSeleccionada,
    required this.onMedusaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona una medusa de la base de datos:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          // Asegúrate de que el nombre de la colección en Firestore coincide exactamente
          stream: FirebaseFirestore.instance.collection('datos_medusas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 50,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Cargando medusas...'),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(12),
                color: Colors.red.shade50,
                child: Text(
                  'Error al cargar medusas: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: const Text(
                  'No se encontraron medusas en la colección "datos_medusas".',
                  style: TextStyle(color: Colors.black87),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return DropdownButtonFormField<String>(
              isExpanded: true,
              value: docs.any((doc) => doc.id == medusaIdSeleccionada)
                  ? medusaIdSeleccionada
                  : null,
              hint: const Text('Elige una medusa'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final nombre = data['nombre'] ?? 'Sin nombre';
                final urlImagen = data['url'] as String?;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: (urlImagen != null && urlImagen.isNotEmpty)
                              ? Image.network(
                                  urlImagen,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.bug_report, size: 20),
                                )
                              : const Icon(Icons.bug_report, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onMedusaSelected,
            );
          },
        ),
      ],
    );
  }
}