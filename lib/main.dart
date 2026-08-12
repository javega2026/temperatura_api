import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Importante para cargar el .env
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meteoflutter/screens/burcar_pantalla.dart';
import 'firebase_conexion.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:meteoflutter/screens/pantalla_pruebas/pantalla_pruebas.dart';
//import 'package:meteoflutter/screens/formulario_pruebas/formulario_pantalla.dart';
//import 'package:meteoflutter/screens/formulario_crud/archivo_listar.dart';
//import 'package:meteoflutter/screens/formulario_medusas_usuario/crear_medusa_pantalla.dart';

void main() async {
  // 1. Asegurar la inicialización de los enlaces de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cargar el archivo .env de forma segura antes de iniciar la app
  await dotenv.load(fileName: ".env");

  // 3. Inicializar Hive para Flutter
  await Hive.initFlutter();

  // 4. Abrir la caja donde guardaremos nuestros datos
  await Hive.openBox('configuracionBox');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Añade esta línea para habilitar el DebugView explícitamente en desarrollo:
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteorologico App',
      debugShowCheckedModeBanner: false,
      // Añadido: Observador para registrar todas las pantallas automáticamente
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],

      theme: ThemeData(primarySwatch: Colors.blue),

      home: const BuscarPantalla(),
      // home : const PantallaPruebas(),
      //home:const FormularioPantalla(),
      //home:  const ArchivoListar(),
     // home : const CrearMedusaPantalla(),
    );
  }
}//


