import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importante para leer el .env
import '../../models/usuario_modelo.dart';

class UsuarioRegistradoOk extends StatefulWidget {
  const UsuarioRegistradoOk({super.key});

  @override
  State<UsuarioRegistradoOk> createState() => _UsuarioRegistradoOkState();
}

class _UsuarioRegistradoOkState extends State<UsuarioRegistradoOk> {
  bool _cargando = true;
  List<MapEntry<String, UsuarioModelo>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _initAdminYCargar();
  }

  Future<void> _initAdminYCargar() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return _salir();

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      if (!doc.exists ||
          (doc.data()?['rol'] ?? '').toString().trim() != 'Administrador') {
        _mostrarError(
          'Acceso denegado: Se requieren permisos de administrador',
        );
        return _salir();
      }
      await _cargarUsuarios();
    } catch (e) {
      _mostrarError('Error: $e');
      setState(() => _cargando = false);
    }
  }

  Future<void> _cargarUsuarios() async {
    final snap = await FirebaseFirestore.instance.collection('usuarios').get();
    setState(() {
      _usuarios = snap.docs
          .map((d) => MapEntry(d.id, UsuarioModelo.fromMap(d.data(), d.id)))
          .toList();
      _cargando = false;
    });
  }

  Future<void> _borrar(String id) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(id).delete();
    _cargarUsuarios();
    _mostrarError('Usuario borrado correctamente');
  }

  /*
     mounted  -->  Es una propiedad que tienen los StatefulWidget en Flutter.
     Su valor es true si el widget sigue activo y visible en la pantalla, 
     y pasa a ser false si el usuario ya ha salido de esa pantalla o 
     si el widget ya ha sido destruido (disposed).
  */
  void _salir() {
    if (mounted) Navigator.pop(context);
  }

  void _mostrarError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: _usuarios.isEmpty
                        ? const Center(child: Text('No hay usuarios.'))
                        : ListView.builder(
                            itemCount: _usuarios.length,
                            itemBuilder: (context, i) {
                              final id = _usuarios[i].key;
                              final u = _usuarios[i].value;
                              return Card(
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    u.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Email: ${u.email}\nRol: ${u.rol}',
                                  ),
                                  isThreeLine: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ActualizarUsuarioPantalla(
                                                    id: id,
                                                    nombre: u.nombre,
                                                    email: u.email,
                                                    rolActual: u.rol,
                                                  ),
                                            ),
                                          );
                                          _cargarUsuarios();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('Eliminar'),
                                            content: const Text(
                                              '¿Estás seguro?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _borrar(id);
                                                },
                                                child: const Text(
                                                  'Eliminar',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        _salir();
                      },
                      child: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
  final String id;
  final String nombre;
  final String email;
  final String rolActual;

  const ActualizarUsuarioPantalla({
    super.key,
    required this.id,
    required this.nombre,
    required this.email,
    required this.rolActual,
  });

  @override
  State<ActualizarUsuarioPantalla> createState() => _ActualizarUsuarioState();
}

class _ActualizarUsuarioState extends State<ActualizarUsuarioPantalla> {
  late final TextEditingController _nombre = TextEditingController(
    text: widget.nombre,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.email,
  );
  final TextEditingController _codigoSecreto =
      TextEditingController(); // Controlador para el código automático del .env
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _codigoSecreto.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);

    // Determinamos el rol de forma automática según el código del .env
    final codigoIngresado = _codigoSecreto.text.trim();
    String rolAsignado =
        widget.rolActual; // Por defecto mantiene el rol que ya tenía

    if (codigoIngresado.isNotEmpty) {
      final adminCode = dotenv.env['ADMIN_SECRET_CODE']?.trim() ?? '';
      final userCode = dotenv.env['USER_SECRET_CODE']?.trim() ?? '';

      if (codigoIngresado == adminCode) {
        rolAsignado = 'Administrador';
      } else if (codigoIngresado == userCode) {
        rolAsignado = 'Usuario';
      } else {
        setState(() => _guardando = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Código secreto incorrecto. No se pudo asignar rol.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.id)
          .update({
            'nombre': _nombre.text.trim(),
            'email': _email.text.trim(),
            'rol': rolAsignado, // Se guarda el rol generado automáticamente
          });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              // Ya no hay desplegable de roles; el rol se genera automáticamente introduciendo el código del .env
              TextField(
                controller: _codigoSecreto,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Código secreto de validación',
                  helperText:
                      'Introduce el código de Admin o Usuario para cambiar/generar el rol automáticamente (o déjalo en blanco)',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Rol actual: ${widget.rolActual}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
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
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
