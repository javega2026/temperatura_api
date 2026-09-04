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
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('datos_medusas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return const Text(
                'No hay documentos en la colección datos_medusas.',
                style: TextStyle(color: Colors.red),
              );
            }

            return DropdownButtonFormField<String>(
              initialValue: medusaIdSeleccionada,
              hint: const Text('Elige una medusa'),
              isExpanded: true,
              selectedItemBuilder: (context) {
                return docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String nombre = data['nombre'] ?? 'Sin nombre';
                  final String urlImagen = data['url'] ?? '';

                  return Row(
                    children: [
                      if (urlImagen.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            urlImagen,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 30),
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
                  );
                }).toList();
              },
              items: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final String nombre = data['nombre'] ?? 'Sin nombre';
                final String urlImagen = data['url'] ?? '';

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Row(
                    children: [
                      if (urlImagen.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            urlImagen,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50),
                          ),
                        )
                      else
                        const Icon(Icons.image, size: 30, color: Colors.grey),
                      const SizedBox(width: 12),
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