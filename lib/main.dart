
import 'package:flutter/material.dart';
import 'package:meteoflutter/screens/burcar_pantalla.dart';

import 'package:meteoflutter/screens/temperatura_pantalla_dinamica.dart';


void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Superheroe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const TemperaturaPantalla(),
       home: const BuscarPantalla(),
    );
  }
}