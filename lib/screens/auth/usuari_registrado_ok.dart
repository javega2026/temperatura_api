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
  List<String> _listaIdsDocumentos = [];

  @override
  void initState() {
    super.initState();
    _cargarTodosLosUsuarios();
  }

  Future<void> _cargarTodosLosUsuarios() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .get();

      final List<UsuarioModelo> usuariosTemp = [];
      final List<String> idsTemp = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        usuariosTemp.add(UsuarioModelo.fromMap(data, doc.id)); 
        idsTemp.add(doc.id);
      }

      setState(() {
        _listaUsuarios = usuariosTemp;
        _listaIdsDocumentos = idsTemp;
        _cargandoDatos = false;
      });
    } catch (e) {
      setState(() {
        _cargandoDatos = false;
      });
    }
  }

  Future<void> _borrarUsuario(String idDoc) async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(idDoc).delete();
      _cargarTodosLosUsuarios();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario borrado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al borrar: $e')),
      );
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
                  Expanded(
                    child: _listaUsuarios.isEmpty
                        ? const Center(child: Text('No hay usuarios registrados.'))
                        : ListView.builder(
                            itemCount: _listaUsuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = _listaUsuarios[index];
                              final idFirestore = _listaIdsDocumentos[index];

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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ActualizarUsuarioPantalla(
                                                usuarioId: idFirestore,
                                                nombreActual: usuario.nombre,
                                                emailActual: usuario.email,
                                                rolActual: usuario.rol,
                                              ),
                                            ),
                                          );
                                          _cargarTodosLosUsuarios();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Eliminar usuario'),
                                              content: const Text('¿Estás seguro de que deseas borrar este usuario?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _borrarUsuario(idFirestore);
                                                  },
                                                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
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

class ActualizarUsuarioPantalla extends StatefulWidget {
  final String usuarioId;
  final String nombreActual;
  final String emailActual;
  final String rolActual;

  const ActualizarUsuarioPantalla({
    super.key,
    required this.usuarioId,
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
  
  // Opciones permitidas para bloquear texto libre
  static const List<String> _rolesPermitidos = ['Usuario', 'Administrador'];
  late String _rolSeleccionado;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreActual);
    _emailController = TextEditingController(text: widget.emailActual);
    
    // Validamos y limpiamos el rol inicial si viniera alterado de antes
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

  Future<void> _actualizarFirestore() async {
    setState(() => _guardando = true);
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.usuarioId)
          .update({
        'nombre': _nombreController.text.trim(),
        'email': _emailController.text.trim(),
        'rol': _rolSeleccionado, // Guardamos la opción limpia del desplegable
      });
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Usuario'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            
            // COMBOBOX ESTRICTO
            DropdownButtonFormField<String>(
              value: _rolSeleccionado,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: _rolesPermitidos.map((String rol) {
                return DropdownMenuItem<String>(
                  value: rol,
                  child: Text(rol),
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

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: _guardando ? null : _actualizarFirestore,
                child: _guardando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Cambios', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}