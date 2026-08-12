import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/playa_lon_lat_modelo.dart'; // Ajusta la ruta si es necesario

class PantallaPruebasGoogleMap extends StatefulWidget {
  const PantallaPruebasGoogleMap({super.key});

  @override
  State<PantallaPruebasGoogleMap> createState() => _PantallaPruebasGoogleMapState();
}

class _PantallaPruebasGoogleMapState extends State<PantallaPruebasGoogleMap> {
  PlayaModelo? _playaSeleccionada;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (playasMalaga.isNotEmpty) {
      _playaSeleccionada = playasMalaga.first;
    }
  }

  void _actualizarCamara(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Google Maps - Playas'),
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

          // 3. Mapa interactivo
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _playaSeleccionada?.latitud ?? 36.7213,
                  _playaSeleccionada?.longitud ?? -4.4101,
                ),
                zoom: 14.0,
              ),
              markers: _playaSeleccionada == null
                  ? {}
                  : {
                      Marker(
                        markerId: MarkerId(_playaSeleccionada!.id),
                        position: LatLng(
                          _playaSeleccionada!.latitud,
                          _playaSeleccionada!.longitud,
                        ),
                        infoWindow: InfoWindow(
                          title: _playaSeleccionada!.nombre,
                          snippet: 'Playa de Málaga',
                        ),
                      ),
                    },
            ),
          ),
        ],
      ),
    );
  }
}