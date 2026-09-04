import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaMedusaGuardadas extends StatelessWidget {
  const ListaMedusaGuardadas({super.key});

  // Función para mostrar la imagen en grande al pulsarla
  void _mostrarImagenGrande(BuildContext context, String urlImagen, String nombreMedusa) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nombreMedusa,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  urlImagen,
                  height: 450,
                  width: 450,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Diálogo para confirmar el borrado
  void _confirmarBorrado(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Medusa'),
        content: const Text('¿Estás seguro de que quieres borrar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('datos_medusas').doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text('Borrar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Función para editar (puedes adaptarla según cómo gestiones tu pantalla de edición)
  void _editarMedusa(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Controladores locales para el diálogo de edición rápido
    final TextEditingController nombreController = TextEditingController(text: data['nombre'] ?? '');
    final TextEditingController cientificoController = TextEditingController(text: data['nombreCientifico'] ?? '');
    final TextEditingController descripcionController = TextEditingController(text: data['descripcion'] ?? '');
    final TextEditingController urlController = TextEditingController(text: data['url'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Medusa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre común'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cientificoController,
                decoration: const InputDecoration(labelText: 'Nombre científico'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL de la imagen'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: () {
              FirebaseFirestore.instance.collection('datos_medusas').doc(doc.id).update({
                'nombre': nombreController.text.trim(),
                'nombreCientifico': cientificoController.text.trim(),
                'descripcion': descripcionController.text.trim(),
                'url': urlController.text.trim(),
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medusas Guardadas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('datos_medusas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos de la base de datos.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay medusas registradas todavía.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final medusaData = docs[index].data() as Map<String, dynamic>;
              
              final String nombre = medusaData['nombre'] ?? 'Sin nombre';
              final String nombreCientifico = medusaData['nombreCientifico'] ?? 'Sin nombre científico';
              final String descripcion = medusaData['descripcion'] ?? 'Sin descripción';
              final String urlImagen = medusaData['url'] ?? '';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  // Imagen miniatura interactiva
                  leading: urlImagen.isNotEmpty
                      ? InkWell(
                          onTap: () => _mostrarImagenGrande(context, urlImagen, nombre),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              urlImagen,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          ),
                        )
                      : const Icon(Icons.water_drop, size: 40, color: Colors.teal),
                  
                  title: Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Científico: $nombreCientifico',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // Botones de Editar (lápiz) y Borrar (papelera)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar medusa',
                        onPressed: () => _editarMedusa(context, docs[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Borrar medusa',
                        onPressed: () => _confirmarBorrado(context, docs[index].id),
                      ),
                    ],
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