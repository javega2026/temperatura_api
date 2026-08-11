import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Importar Firestore
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meteoflutter/screens/auth/usuari_registrado_ok.dart';
import 'registro_screen.dart';
// TODO: Importa aquí tu pantalla principal o buscador para los usuarios normales
// import '../burcar_pantalla.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codigoController = TextEditingController();
  
  bool _cargando = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _iniciarSesion() async {
    // 1. Validar que no haya campos vacíos
    if (_emailController.text.isEmpty || 
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

    // 2. Obtener el valor de la clave de forma segura
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

    // 3. Validar que el código introducido coincida con el del .env
    if (_codigoController.text.trim() != claveEnv.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código introducido no es válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      // 4. Autenticación con Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // 5. Consultar el rol del usuario en Firestore usando su UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .get();

        if (!mounted) return;

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          String rol = data['rol'] ?? 'Usuario';

          // 6. Redirigir según el rol
          if (rol.trim() == 'Administrador') {
            // Si es Admin, va a la lista de usuarios para gestionar
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UsuarioRegistradoOk()),
            );
          } else {
            // Si es un Usuario normal, va a la pantalla principal (cambia BurcarPantalla por la tuya)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Scaffold(
                body: Center(child: Text('Bienvenido Usuario Normal (Pantalla Principal)')),
              )),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No se encontró el perfil de este usuario en la base de datos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String mensajeError = 'Ocurrió un error al iniciar sesión';
      if (e.code == 'user-not-found') {
        mensajeError = 'No existe ningún usuario con este correo.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El formato del correo es inválido.';
      } else if (e.code == 'invalid-credential') {
        mensajeError = 'Credenciales incorrectas o usuario no encontrado.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeError), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_person_rounded,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Accede a tu cuenta para continuar',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 35),
              
              // Campo de Correo
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

              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });

                      if (!_obscurePassword) {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted && !_obscurePassword) {
                            setState(() {
                              _obscurePassword = true;
                            });
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Código (conecta con .env)
              TextField(
                controller: _codigoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Código de acceso',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.pin),
                ),
              ),

              const SizedBox(height: 30),

              // Botón principal de Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _cargando ? null : _iniciarSesion,
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón secundario para ir a la pantalla de Registro
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo[800],
                    side: BorderSide(color: Colors.indigo.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistroScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}