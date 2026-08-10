import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivoActualizar extends StatefulWidget {
  final String documentId;
  final String nombreActual;
  final int cantidadActual;
  final dynamic medidaActual;

  const ArchivoActualizar({
    super.key,
    required this.documentId,
    required this.nombreActual,
    required this.cantidadActual,
    required this.medidaActual,
  });

  @override
  State<ArchivoActualizar> createState() => _ArchivoActualizarState();
}

class _ArchivoActualizarState extends State<ArchivoActualizar> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _cantidadController;
  late TextEditingController _medidaController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores recibidos de la lista
    _nombreController = TextEditingController(text: widget.nombreActual);
    _cantidadController = TextEditingController(text: widget.cantidadActual.toString());
    _medidaController = TextEditingController(text: widget.medidaActual.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _medidaController.dispose();
    super.dispose();
  }

  Future<void> _actualizarEnFirebase() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance
            .collection('pruebas')
            .doc(widget.documentId)
            .update({
          'nombre': _nombreController.text.trim(),
          'cantidad': int.tryParse(_cantidadController.text) ?? 0,
          'medida': double.tryParse(_medidaController.text.replaceAll(',', '.')) ?? 0.0,
        });

        if (mounted) {
          Navigator.pop(context); // Regresa a la lista tras actualizar
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Registro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad', border: OutlineInputBorder()),
                validator: (val) => int.tryParse(val!) == null ? 'Introduce un número entero' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medidaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Medida', border: OutlineInputBorder()),
                validator: (val) => double.tryParse(val!.replaceAll(',', '.')) == null ? 'Introduce un número válido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : _actualizarEnFirebase,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}