import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearMedusaPantalla extends StatefulWidget {
  const CrearMedusaPantalla({super.key});

  @override
  State<CrearMedusaPantalla> createState() => _CrearMedusaPantallaState();
}

class _CrearMedusaPantallaState extends State<CrearMedusaPantalla> {
  final _nombreController = TextEditingController();
  final _playaController = TextEditingController();
  final _peligrosidadController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _playaController.dispose();
    _peligrosidadController.dispose();
    super.dispose();
  }

  Future<void> _guardarMedusa() async {
    if (_nombreController.text.isEmpty || _playaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena al menos el nombre y la playa')),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      // Guardar en la colección 'medusas' de Firestore
      await FirebaseFirestore.instance.collection('medusas').add({
        'nombre': _nombreController.text.trim(),
        'playa': _playaController.text.trim(),
        'peligrosidad': _peligrosidadController.text.trim(),
        'fecha': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medusa registrada correctamente'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Volver a la pantalla anterior
      }
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de la medusa'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _playaController,
              decoration: const InputDecoration(labelText: 'Playa o ubicación'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _peligrosidadController,
              decoration: const InputDecoration(labelText: 'Peligrosidad (Alta, Media, Baja)'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: _guardando ? null : _guardarMedusa,
                child: _guardando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Medusa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}