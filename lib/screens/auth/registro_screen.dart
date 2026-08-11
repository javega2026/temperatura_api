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
  // 1. Declaración correcta de TODOS los controladores (incluyendo el del código)
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  String _rolSeleccionado = 'Usuario';
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
    // 2. Validar que ningún campo esté vacío
    if (_nombreController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _codigoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos incluyendo el código'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 3. Comprobar la variable de entorno CLAVE_CODIGO
    final String? claveEnv = dotenv.env['CLAVE_CODIGO'];

    if (claveEnv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: La variable CLAVE_CODIGO no está definida en el archivo .env'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 4. Validar que el código introducido coincida con el del .env
    if (_codigoController.text.trim() != claveEnv.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código de registro introducido no es válido'),
          backgroundColor: Colors.red,
        ),
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
            'rol': _rolSeleccionado,
            'fechaRegistro': DateTime.now().toString(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta creada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensajeError = 'Error Firebase (${e.code}): ${e.message}';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
        ),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
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

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.amber.shade800,
                  side: BorderSide(color: Colors.amber.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.flash_on),
                label: const Text('Rellenar datos de prueba rápido'),
                onPressed: () {
                  setState(() {
                    _nombreController.text = 'Usuario Prueba';
                    _emailController.text =
                        'test_${DateTime.now().millisecondsSinceEpoch}@test.com';
                    _passwordController.text = '12345678';
                    _codigoController.text = '1234'; // Rellena con el valor de prueba del .env
                    _rolSeleccionado = 'Usuario';
                  });
                },
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
              
              // Campo para el Código de Registro validado con el .env
              TextField(
                controller: _codigoController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Código de Registro (.env)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String?>(
                initialValue: _rolSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Rol de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Usuario',
                    child: Text('Usuario'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Administrador',
                    child: Text('Administrador'),
                  ),
                ],
                onChanged: (String? nuevoValor) {
                  if (nuevoValor != null) {
                    setState(() {
                      _rolSeleccionado = nuevoValor;
                    });
                  }
                },
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