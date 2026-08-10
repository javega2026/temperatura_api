import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivoInsertar extends StatefulWidget {
  const ArchivoInsertar({super.key});

  @override
  State<ArchivoInsertar> createState() => _ArchivoInsertarState();
}

class _ArchivoInsertarState extends State<ArchivoInsertar> {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar lo que el usuario escribe
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _medidaController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Liberamos los controladores cuando se destruya la vista
    _nombreController.dispose();
    _cantidadController.dispose();
    _medidaController.dispose();
    super.dispose();
  }

  // Función para guardar los datos en Firestore
  Future<void> _guardarRegistro() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Convertimos cantidad y medida a números (int / double) de forma segura
        int cantidad = int.tryParse(_cantidadController.text) ?? 0;
        double medida = double.tryParse(_medidaController.text) ?? 0.0;

        // Añadimos el documento a la colección 'pruebas'
        await FirebaseFirestore.instance.collection('pruebas').add({
          'nombre': _nombreController.text.trim(),
          'cantidad': cantidad,
          'medida': medida,
          'fecha': Timestamp.now(), // Opcional: útil si quieres ordenar por fecha
        });

        // Si se guarda con éxito, volvemos a la pantalla anterior
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // Si ocurre un error, mostramos un aviso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nuevo Registro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- CAMPO NOMBRE ---
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.text_fields),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- CAMPO CANTIDAD ---
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce una cantidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Introduce un número entero válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- CAMPO MEDIDA ---
              TextFormField(
                controller: _medidaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Medida',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce una medida';
                  }
                  // Reemplazamos coma por punto por si el usuario usa comas en decimales
                  String valCorregido = value.replaceAll(',', '.');
                  if (double.tryParse(valCorregido) == null) {
                    return 'Introduce un número válido (ej: 3.3)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- BOTÓN GUARDAR ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : _guardarRegistro,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Guardar Registro',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}