import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/screens/formulario_crud/archivo_actualizar.dart';
import 'package:meteoflutter/screens/formulario_crud/archivo_insertar.dart';

class ArchivoListar extends StatefulWidget {
  const ArchivoListar({super.key});

  @override
  State<ArchivoListar> createState() => _ArchivoListarState();
}

class _ArchivoListarState extends State<ArchivoListar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pruebas').snapshots(),
      builder: (context, snapshot) {
        int totalRegistros = 0;
        if (snapshot.hasData) {
          totalRegistros = snapshot.data!.docs.length;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Registros ($totalRegistros)'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: () {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Ha ocurrido un error al cargar los datos'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No hay registros todavía.'));
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                final String nombre = data['nombre'] ?? 'Sin nombre';
                final int cantidad = data['cantidad'] ?? 0;
                final dynamic medida = data['medida'] ?? 0;

                return Card(
                  color: Colors.blueGrey.shade50,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26.0,
                      vertical: 18.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Columna con el nombre y los valores a la izquierda
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- AÑADIMOS EL NOMBRE AQUÍ ---
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 5,
                                ),
                                child: Text(
                                  nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // --- CANTIDAD Y MEDIDA ---
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Cantidad: '),
                                    TextSpan(
                                      text: '$cantidad',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const TextSpan(text: ' | Medida: '),
                                    TextSpan(
                                      text: '$medida',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botones de acción a la derecha, en la misma línea
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () {
                                // Navegamos a la pantalla de edición pasando el ID y los datos actuales
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ArchivoActualizar(documentId:doc.id,nombreActual:nombre,cantidadActual:cantidad,medidaActual:medida,),),);








                              },
                            ),
                    IconButton(
  constraints: const BoxConstraints(),
  padding: const EdgeInsets.all(8),
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
    size: 20,
  ),
  onPressed: () {
    // Ventana emergente de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar registro'),
          content: const Text('¿Estás seguro de que quieres borrar este elemento?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(), // Cierra la ventana sin hacer nada
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra la ventana de diálogo
                // Borra el documento en Firebase
                await FirebaseFirestore.instance
                    .collection('pruebas')
                    .doc(doc.id)
                    .delete();
              },
            ),
          ],
        );
      },
    );
  },
),







                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () {
              // Aquí abriremos el formulario de inserción
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArchivoInsertar(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
