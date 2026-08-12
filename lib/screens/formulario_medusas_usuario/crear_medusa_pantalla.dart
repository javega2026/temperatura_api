import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lista_medusa_guardadas.dart';

class CrearMedusaPantalla extends StatefulWidget {
  const CrearMedusaPantalla({super.key});

  @override
  State<CrearMedusaPantalla> createState() => _CrearMedusaPantallaState();
}

class _CrearMedusaPantallaState extends State<CrearMedusaPantalla> {
  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nombreCientificoController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _nombreCientificoController.dispose();
    _urlController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarMedusa() async {
    if (_nombreController.text.isEmpty || _nombreCientificoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena al menos el nombre y el nombre científico')),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      await FirebaseFirestore.instance.collection('datos_medusas').add({
        'nombre': _nombreController.text.trim(),
        'nombreCientifico': _nombreCientificoController.text.trim(),
        'url': _urlController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medusa registrada correctamente'), backgroundColor: Colors.green),
      );

      _nombreController.clear();
      _nombreCientificoController.clear();
      _urlController.clear();
      _descripcionController.clear();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Medusa'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // StreamBuilder para contar en tiempo real los registros de Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('datos_medusas').snapshots(),
            builder: (context, snapshot) {
              int total = 0;
              if (snapshot.hasData) {
                total = snapshot.data!.docs.length;
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Registros: $total',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
          
          // Botón para navegar a la lista
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ver lista guardada',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListaMedusaGuardadas(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre común',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreCientificoController,
              decoration: const InputDecoration(
                labelText: 'Nombre científico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL de la imagen',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _guardando ? null : _guardarMedusa,
                child: _guardando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Guardar Medusa',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}