import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/servicios/clima_servicio1.dart';

class TemperaturaPantallaDinamica extends StatefulWidget {
  const TemperaturaPantallaDinamica({super.key});

  @override
  State<TemperaturaPantallaDinamica> createState() => _TemperaturaPantallaDinamicaState();
}

class _TemperaturaPantallaDinamicaState extends State<TemperaturaPantallaDinamica> {
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
      _climaActual = null;
    });

    final resultado = await _climaServicio.obtenerClimaPorCiudad(ciudad);

    setState(() {
      _cargando = false;
      if (resultado != null) {
        _climaActual = resultado;
      } else {
        _mensajeError = 'No se encontraron datos para "$ciudad"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String tituloAppBar = 'Buscador de Clima';
    if (_climaActual != null) {
      tituloAppBar = 'Clima en ${_climaActual!.nombreCiudad}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        // Sin botón de atrás porque es la pantalla principal
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextField(
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
                onSubmitted: (value) => _buscarClima(),
              ),
            ),

            if (_cargando) 
              const Center(child: CircularProgressIndicator()),

            if (_mensajeError != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _mensajeError!,
                  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            if (_climaActual != null) ...[
              // Tarjeta principal con el Mapa de Coordenadas y la Temperatura
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // --- MAPA DINÁMICO POR COORDENADAS (Sin Key) ---
                    Image.network(
                      'https://static-maps.yandex.ru/1.x/?ll=${_climaActual!.lon},${_climaActual!.lat}&size=600,200&z=10&l=map&pt=${_climaActual!.lon},${_climaActual!.lat},pm2rdm',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 140,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: Colors.blue[50],
                        child: const Center(
                          child: Icon(Icons.map, size: 50, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            _climaActual!.nombreCiudad,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_climaActual!.temperatura.toStringAsFixed(1)} °C',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Sensación térmica: ${_climaActual!.sensTermica.toStringAsFixed(1)} °C',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detalles en cuadrícula
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _buildTarjetasDetalle(
                    'Sensación Térmica', 
                    '${_climaActual!.sensTermica.toStringAsFixed(1)} °C', 
                    Icons.thermostat
                  ),
                  _buildTarjetasDetalle(
                    'Humedad', 
                    '${_climaActual!.humedad} %', 
                    Icons.water_drop
                  ),
                ],
              ),
            ],

            if (_climaActual == null && !_cargando && _mensajeError == null)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("Introduce una provincia para ver el clima", style: TextStyle(color: Colors.grey, fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetasDetalle(String titulo, String valor, IconData icono) {
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