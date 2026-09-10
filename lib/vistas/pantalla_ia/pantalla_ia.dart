import 'package:flutter/material.dart';
import 'package:meteoflutter/servicios/ia_servicio.dart';

class PantallaIa extends StatefulWidget {
  final String ciudad;

  const PantallaIa({
    super.key,
    required this.ciudad,
  });

  @override
  State<PantallaIa> createState() => _PantallaIaState();
}

class _PantallaIaState extends State<PantallaIa> {
  final IaServicio _iaServicio = IaServicio();
  late Future<String> _futureAnalisis;

  @override
  void initState() {
    super.initState();
    _futureAnalisis = _iaServicio.obtenerAnalisisMedusas(ciudad: widget.ciudad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análisis de Medusas - ${widget.ciudad}'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<String>(
        future: _futureAnalisis,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Consultando a la IA...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                snapshot.data!,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            );
          }
          return const Center(child: Text('Sin datos disponibles.'));
        },
      ),
    );
  }
}