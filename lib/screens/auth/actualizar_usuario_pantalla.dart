import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActualizarUsuarioPantalla extends StatefulWidget {
  final String userId;
  final String nombreActual;
  final String emailActual;
  final String rolActual;

  const ActualizarUsuarioPantalla({
    super.key,
    required this.userId,
    required this.nombreActual,
    required this.emailActual,
    required this.rolActual,
  });

  @override
  State<ActualizarUsuarioPantalla> createState() => _ActualizarUsuarioPantallaState();
}

class _ActualizarUsuarioPantallaState extends State<ActualizarUsuarioPantalla> {
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  
  static const List<String> _rolesPermitidos = ['Usuario', 'Administrador'];
  late String _rolSeleccionado;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreActual);
    _emailController = TextEditingController(text: widget.emailActual);
    
    String rolLimpio = widget.rolActual.trim();
    if (_rolesPermitidos.contains(rolLimpio)) {
      _rolSeleccionado = rolLimpio;
    } else {
      _rolSeleccionado = 'Usuario'; 
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _actualizarDatos() async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(widget.userId)
        .update({
      'nombre': _nombreController.text.trim(),
      'email': _emailController.text.trim(),
      'rol': _rolSeleccionado, 
    });
    
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // 🟡 FONDO AMARILLO EXAGERADO
      appBar: AppBar(
        title: const Text('¡PRUEBA EXAGERADA ACTIVADA!'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '¡ESTOY EN EL ARCHIVO NUEVO!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // COMBOBOX OBLIGATORIO
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: _rolSeleccionado,
                decoration: const InputDecoration(labelText: 'Rol Estricto (Sin Texto Libre)'),
                items: _rolesPermitidos.map((String rol) {
                  return DropdownMenuItem<String>(
                    value: rol,
                    child: Text(rol, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (String? nuevoRol) {
                  if (nuevoRol != null) {
                    setState(() {
                      _rolSeleccionado = nuevoRol;
                    });
                  }
                },
              ),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.yellow,
                ),
                onPressed: _actualizarDatos,
                child: const Text(
                  'GUARDAR CAMBIOS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}