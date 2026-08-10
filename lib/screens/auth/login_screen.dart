import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meteoflutter/screens/auth/usuari_registrado_ok.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _cargando = false;
  bool _obscurePassword = true; // Empieza ocultando la contraseña

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Navegamos a la nueva pantalla de éxito y borramos el historial de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UsuarioRegistradoOk()),
      );
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
                obscureText:
                    _obscurePassword, // Vinculamos la variable de estado
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),

                  // Añadimos el botón del ojo al final (suffixIcon)
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword; // Cambia el estado al pulsar
                      });

                      // Si acabamos de mostrar la contraseña (es decir, ahora es false),
                      // programamos un temporizador de 3 segundos para volver a ocultarla
                      if (!_obscurePassword) {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          // Nos aseguramos de que el widget siga activo antes de llamar a setState
                          if (mounted && !_obscurePassword) {
                            setState(() {
                              _obscurePassword =
                                  true; // Vuelve a ocultarse con puntos (****)
                            });
                          }
                        });
                      }
                    },
                  ),
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
