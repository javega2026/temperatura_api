import 'package:flutter/material.dart';
import 'package:meteoflutter/servicios/clima_servicio1.dart';
import 'package:meteoflutter/screens/temperatura_pantalla_dinamica.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class BuscarPantalla extends StatefulWidget {
  const BuscarPantalla({super.key});

  @override
  State<BuscarPantalla> createState() => _BuscarPantallaState();
}

class _BuscarPantallaState extends State<BuscarPantalla> {
  final TextEditingController _controladorCiudad = TextEditingController();
  final ClimaServicio1 _climaServicio = ClimaServicio1();
  bool _cargando = false;
  String? _mensajeError;

  void _buscarClima() async {
    final ciudad = _controladorCiudad.text.trim();
    if (ciudad.isEmpty) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final resultado = await _climaServicio.obtenerClimaPorCiudad(ciudad);

    setState(() {
      _cargando = false;
    });

    if (resultado != null) {
      if (!mounted) return;
    
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TemperaturaPantallaDinamica(clima: resultado),
        ),
      );
    } else {
      setState(() {
        _mensajeError = 'No se encontraron datos para "$ciudad"';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Clima'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_rounded, size: 80, color: Colors.orangeAccent),
            const SizedBox(height: 20),
            const Text(
              '¿Qué tiempo hace hoy?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controladorCiudad,
              decoration: InputDecoration(
                labelText: 'Escribe una provincia (ej. Sevilla)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (value) => _buscarClima(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _cargando ? null : _buscarClima,
                child: _cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Consultar Clima', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            
         






            
        // ------------------------------ BOTÓN DE PRUEBA GUARDAR EN FIREBASE ------------------------------
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green[800],
                side: BorderSide(color: Colors.green.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Guardar Prueba en Firebase', style: TextStyle(fontSize: 15)),
              onPressed: () async {
                final datosPrueba = {
                  'temperatura': '22°C',
                  'humedad': '60%',
                  'fecha': DateTime.now().toString(),
                };

                try {
                  // Esto envía los datos directamente a la nube de Firebase
                  await FirebaseFirestore.instance.collection('pruebas').add(datosPrueba);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Datos guardados en Firebase con éxito!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al guardar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
           
           
           
           
           
           
           
            // -------------------------------

            if (_mensajeError != null) ...[
              const SizedBox(height: 20),
              Text(
                _mensajeError!,
                style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}



// debugPrint('--- RESULTADO DE PRUEBA ---');