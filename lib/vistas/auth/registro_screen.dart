import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _registrarUsuario() async {
    // 1. Validar que ningún campo esté vacío
    if (_nombreController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _codigoController.text.isEmpty) {
      if (!mounted) return;
      _mostrarAlerta(
        'Campos incompletos', 
        'Por favor, rellena todos los campos incluyendo el código.', 
        Colors.orange
      );
      return;
    }

    // 2. Obtener los códigos estrictamente desde el archivo .env (sin valores por defecto expuestos)
    final String adminCode = dotenv.env['ADMIN_SECRET_CODE']?.trim() ?? '';
    final String userCode = dotenv.env['USER_SECRET_CODE']?.trim() ?? '';

    if (adminCode.isEmpty || userCode.isEmpty) {
      if (!mounted) return;
      _mostrarAlerta(
        'Error de Configuración', 
        'No se pudieron cargar los códigos de seguridad desde el archivo .env.', 
        Colors.red
      );
      return;
    }

    // 3. Determinar el rol según el código introducido
    final String codigoIngresado = _codigoController.text.trim();
    String rolAsignado;

    if (codigoIngresado == adminCode) {
      rolAsignado = 'Administrador';
    } else if (codigoIngresado == userCode) {
      rolAsignado = 'Usuario';
    } else {
      if (!mounted) return;
      _mostrarAlerta(
        'Código Incorrecto', 
        'El código de registro introducido no es válido.', 
        Colors.red
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      UserCredential credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credencial.user!.uid)
          .set({
            'nombre': _nombreController.text.trim(),
            'email': _emailController.text.trim(),
            'rol': rolAsignado,
            'fechaRegistro': DateTime.now().toString(),
          });

      if (!mounted) return;

      _mostrarAlerta(
        '¡Éxito!', 
        'Cuenta creada con éxito.', 
        Colors.green, 
        esExito: true
      );
    } on FirebaseAuthException catch (e) {
      String mensajeError = 'Error Firebase (${e.code}): ${e.message}';

      if (!mounted) return;
      _mostrarAlerta('Error de Registro', mensajeError, Colors.red);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // Método para rellenar datos de prueba como Usuario (leyendo del .env de forma segura)
  void _rellenarDatosUsuario() {
    final String userCode = dotenv.env['USER_SECRET_CODE']?.trim() ?? '';
    setState(() {
      _nombreController.text = 'Sandra';
      _emailController.text = 'test_${DateTime.now().millisecondsSinceEpoch}@test.com';
      _passwordController.text = '123456';
      _codigoController.text = userCode; // Carga el código desde el .env dinámicamente
    });
  }

  // Método para rellenar datos de prueba como Administrador (leyendo del .env de forma segura)
  void _rellenarDatosAdmin() {
    final String adminCode = dotenv.env['ADMIN_SECRET_CODE']?.trim() ?? '';
    setState(() {
      _nombreController.text = 'Admin Prueba';
      _emailController.text = 'admin_${DateTime.now().millisecondsSinceEpoch}@test.com';
      _passwordController.text = '123456';
      _codigoController.text = adminCode; // Carga el código desde el .env dinámicamente
    });
  }

  // Método auxiliar para mostrar alertas visuales claras en Web y Móvil
  void _mostrarAlerta(String titulo, String mensaje, Color color, {bool esExito = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra la alerta
              if (esExito) {
                Navigator.pop(context); // Si fue éxito, vuelve a la pantalla anterior
              }
            },
            child: const Text('Aceptar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add_rounded,
                size: 70,
                color: Colors.purple,
              ),
              const SizedBox(height: 10),
              const Text(
                'Crea una nueva cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 25),

              // Botón de prueba rápido para USUARIO (usa el método seguro)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.amber.shade800,
                  side: BorderSide(color: Colors.amber.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.flash_on),
                label: const Text('Rellenar datos de Usuario'),
                onPressed: _rellenarDatosUsuario,
              ),
              const SizedBox(height: 10),

              // Botón de prueba rápido para ADMIN (usa el método seguro)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.purple.shade700,
                  side: BorderSide(color: Colors.purple.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Rellenar datos de Admin'),
                onPressed: _rellenarDatosAdmin,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre y Apellidos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña (mínimo 6 caracteres)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _codigoController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Código de Registro (.env)',
                  helperText: 'Introduce el código secreto correspondiente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _cargando ? null : _registrarUsuario,
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}