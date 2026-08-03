import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';
import 'package:meteoflutter/servicios/clima_servicio1.dart'; // Asegura la ruta
// Asegura la ruta

class TemperaturaPantallaDinamica extends StatefulWidget {
  const TemperaturaPantallaDinamica({super.key});

  @override
  State<TemperaturaPantallaDinamica> createState() => _TemperaturaPantallaDinamicaState();
}

class _TemperaturaPantallaDinamicaState extends State<TemperaturaPantallaDinamica> {
  // Controlador para el campo de texto
  final TextEditingController _controladorCiudad = TextEditingController();
  
  // Instancia del servicio
  final ClimaServicio1 _climaServicio = ClimaServicio1();
  
  // Variable para guardar el clima obtenido (inicialmente nulo)
  ClimaModelo1? _climaActual;
  bool _cargando = false;
  String? _mensajeError;

  // Función para llamar al servicio y actualizar el estado
  void _buscarClima() async {
    final ciudad = _controladorCiudad.text.trim();
    if (ciudad.isEmpty) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
      // Opcional: limpiar el clima anterior mientras carga
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
    // Título dinámico del AppBar
    String tituloAppBar = 'Buscador de Clima';
    if (_climaActual != null) {
      tituloAppBar = 'Clima en ${_climaActual!.nombreCiudad}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- NUEVO: Campo de búsqueda ---
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
                    onPressed: _buscarClima, // Ejecuta la búsqueda
                  ),
                ),
                // Permite buscar también al pulsar "Enter" en el teclado
                onSubmitted: (value) => _buscarClima(),
              ),
            ),

            // --- Indicador de carga ---
            if (_cargando) 
              const Center(child: CircularProgressIndicator()),

            // --- Mensaje de error ---
            if (_mensajeError != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _mensajeError!,
                  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            // --- MUESTRA DE DATOS (Solo si _climaActual no es nulo) ---
            if (_climaActual != null) ...[
              // Tarjeta principal de Temperatura
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
                      const Icon(Icons.cloud, size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 10),
                      Text(
                        // Usamos el dato dinámico
                        '${_climaActual!.temperatura.toStringAsFixed(1)} °C',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // NOTA: He quitado la descripción larga porque el modelo
                      // simplificado no la trae, pero se puede añadir.
                      const SizedBox(height: 15),
                      Text(
                        'Sensación térmica: ${_climaActual!.sensTermica.toStringAsFixed(1)} °C',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Detalles en cuadrícula (Sensación térmica y Humedad)
              // He simplificado a 2 tarjetas para ajustarme a tu modelo de 4 campos
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
            // Si no se ha buscado nada aún, mostrar un mensaje inicial
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

  // Widget auxiliar para las tarjetas pequeñas de detalles
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