import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/servicios/clima_servicio1.dart';
 // Ajusta la ruta según tu estructura de carpetas

class TemperaturaPantalla1 extends StatefulWidget {
  const TemperaturaPantalla1({super.key});

  @override
  State<TemperaturaPantalla1> createState() => _TemperaturaPantalla1State();
}

class _TemperaturaPantalla1State extends State<TemperaturaPantalla1> {
  final TextEditingController _controladorCiudad = TextEditingController();
  final ClimaServicio1 _climaServicio = ClimaServicio1();
  
  ClimaModelo1? _climaActual;
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
      if (resultado != null) {
        _climaActual = resultado;
      } else {
        _mensajeError = 'No se pudo encontrar el clima para "$ciudad".';
        _climaActual = null;
      }
    });
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input para la provincia / ciudad
            TextField(
              controller: _controladorCiudad,
              decoration: InputDecoration(
                labelText: 'Escribe una provincia (ej. Sevilla)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _buscarClima,
                ),
              ),
              onSubmitted: (_) => _buscarClima(),
            ),
            const SizedBox(height: 20),

            // Indicador de carga
            if (_cargando)
              const CircularProgressIndicator(),

            // Mensaje de error si falla
            if (_mensajeError != null)
              Text(
                _mensajeError!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),

            // Mostrar los datos si ya se han cargado
            if (_climaActual != null && !_cargando)
              Expanded(
                child: ListView(
                  children: [
                    // Tarjeta Principal (Ciudad y Temperatura)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(Icons.cloud, size: 70, color: Colors.blueAccent),
                            const SizedBox(height: 10),
                            Text(
                              _climaActual!.nombreCiudad,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_climaActual!.temperatura.toStringAsFixed(1)} °C',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Cuadrícula con los otros campos simplificados
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _buildTarjetaDetalle(
                          'Sensación Térmica',
                          '${_climaActual!.sensTermica.toStringAsFixed(1)} °C',
                          Icons.thermostat,
                        ),
                        _buildTarjetaDetalle(
                          'Humedad',
                          '${_climaActual!.humedad} %',
                          Icons.water_drop,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las tarjetas pequeñas
  Widget _buildTarjetaDetalle(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.blueAccent, size: 28),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}