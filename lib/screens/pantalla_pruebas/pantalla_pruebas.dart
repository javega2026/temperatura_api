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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. BOTÓN DE GUARDAR (Arriba)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Guardar 4 Registros en Firebase'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  final listaPruebas = [
                    {
                      'temperatura': '20ºC',
                      'humedad': '50%',
                      'fecha': DateTime.now().toString(),
                    },
                    {
                      'temperatura': '22ºC',
                      'humedad': '60%',
                      'fecha': DateTime.now().toString(),
                    },
                    {
                      'temperatura': '25ºC',
                      'humedad': '45%',
                      'fecha': DateTime.now().toString(),
                    },
                    {
                      'temperatura': '18ºC',
                      'humedad': '75%',
                      'fecha': DateTime.now().toString(),
                    },
                  ];

                  try {
                    for (var registro in listaPruebas) {
                      await FirebaseFirestore.instance
                          .collection('pruebas')
                          .add(registro);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡4 registros guardados con éxito!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
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
            
            const SizedBox(height: 20),
            const Text(
              "Datos en tiempo real desde Firebase:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // 2. LISTA DE TARJETAS (En el medio, usando Expanded para ocupar el espacio central)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('pruebas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No hay datos guardados todavía"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      
                      // Convertimos cada registro en una tarjeta visual tipo fila de datos
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Temp: ${data['temperatura']}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Humedad: ${data['humedad']}"),
                                ],
                              ),
                              Text(
                                data['fecha'] != null ? data['fecha'].toString().substring(11, 19) : '',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 3. BOTÓN DE BORRAR (Abajo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                label: const Text('Borrar todos los datos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  try {
                    final collectionRef = FirebaseFirestore.instance.collection('pruebas');
                    final snapshot = await collectionRef.get();

                    for (var doc in snapshot.docs) {
                      await doc.reference.delete();
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Todos los datos fueron borrados con éxito!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al borrar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}