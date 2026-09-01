import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/playa_lon_lat_modelo.dart'; // Ajusta la ruta si es necesario

class PantallaPruebasOpenMap extends StatefulWidget {
  const PantallaPruebasOpenMap({super.key});

  @override
  State<PantallaPruebasOpenMap> createState() => _PantallaPruebasOpenMapState();
}

class _PantallaPruebasOpenMapState extends State<PantallaPruebasOpenMap> {
  PlayaModelo? _playaSeleccionada;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (playasMalaga.isNotEmpty) {
      _playaSeleccionada = playasMalaga.first;
    }
  }

  void _actualizarCamara(double lat, double lng) {
    // En flutter_map se mueve la cámara así de fácil con el MapController
    _mapController.move(LatLng(lat, lng), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    final LatLng posicionActual = _playaSeleccionada != null
        ? LatLng(_playaSeleccionada!.latitud, _playaSeleccionada!.longitud)
        : const LatLng(36.7213, -4.4101); // Coordenadas por defecto (Málaga centro)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba OpenStreetMap - Playas'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // 1. Selector desplegable de playas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<PlayaModelo>(
              value: _playaSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Selecciona una playa',
                border: OutlineInputBorder(),
              ),
              items: playasMalaga.map((playa) {
                return DropdownMenuItem<PlayaModelo>(
                  value: playa,
                  child: Text(playa.nombre),
                );
              }).toList(),
              onChanged: (PlayaModelo? nuevaPlaya) {
                if (nuevaPlaya != null) {
                  setState(() {
                    _playaSeleccionada = nuevaPlaya;
                  });
                  _actualizarCamara(nuevaPlaya.latitud, nuevaPlaya.longitud);
                }
              },
            ),
          ),

          // 2. Información de coordenadas
          if (_playaSeleccionada != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lat: ${_playaSeleccionada!.latitud} | Lng: ${_playaSeleccionada!.longitud}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 10),

          // 3. Mapa interactivo con OpenStreetMap
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: posicionActual,
                initialZoom: 14.0,
              ),
              children: [
                // Capa de diseño del mapa gratuita
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.meteoflutter',
                ),
                // Capa de marcadores para la playa seleccionada
                MarkerLayer(
                  markers: _playaSeleccionada == null
                      ? []
                      : [
                          Marker(
                            point: posicionActual,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 45,
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}