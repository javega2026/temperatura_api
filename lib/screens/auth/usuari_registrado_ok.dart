import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario_modelo.dart'; 

class UsuarioRegistradoOk extends StatefulWidget {
  const UsuarioRegistradoOk({super.key});

  @override
  State<UsuarioRegistradoOk> createState() => _UsuarioRegistradoOkState();
}

class _UsuarioRegistradoOkState extends State<UsuarioRegistradoOk> {
  bool _cargandoDatos = true;
  List<UsuarioModelo> _listaUsuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarTodosLosUsuarios();
  }

  // Método para obtener todos los documentos de la colección 'usuarios'
  Future<void> _cargarTodosLosUsuarios() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .get();

      final List<UsuarioModelo> usuariosTemp = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UsuarioModelo.fromMap(data, doc.id);
      }).toList();

      setState(() {
        _listaUsuarios = usuariosTemp;
        _cargandoDatos = false;
      });
    } catch (e) {
      setState(() {
        _cargandoDatos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios en BD'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _cargandoDatos
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Registros encontrados en Firestore:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Lista dinámica de usuarios
                  Expanded(
                    child: _listaUsuarios.isEmpty
                        ? const Center(child: Text('No hay usuarios registrados.'))
                        : ListView.builder(
                            itemCount: _listaUsuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = _listaUsuarios[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(
                                    usuario.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('Email: ${usuario.email}'),
                                      Text('Rol: ${usuario.rol}'),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),
                  
                  // Botón de Cerrar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cerrar Sesión',
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