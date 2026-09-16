import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MostrarMapaMedusas extends StatelessWidget {
  const MostrarMapaMedusas({super.key});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Avistamientos'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reportes_medusas')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar el mapa: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          final List<Marker> marcadores = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final double latBase = (data['latitud'] as num?)?.toDouble() ?? 0.0;
            final double lngBase = (data['longitud'] as num?)?.toDouble() ?? 0.0;
            final String playa = data['playa'] ?? 'Playa desconocida';
            final String provincia = data['provincia'] ?? '';
            final String medusa = data['nombre_comun'] ?? 'Medusa no especificada';
            final String nivel = data['nivel_medusas'] ?? 'N/A';
            final String? urlImagen = data['imagen'] as String?;

            // Si la coordenada es válida (distinta de 0), aplicamos un pequeño offset
            // de ~30 a 50 metros para evitar que múltiples marcadores en la misma playa tapen a los demás.
            double latAjustada = latBase;
            double lngAjustada = lngBase;

            if (latBase != 0.0 && lngBase != 0.0) {
              final double offsetLat = (random.nextDouble() - 0.5) * 0.0004;
              final double offsetLng = (random.nextDouble() - 0.5) * 0.0004;
              latAjustada += offsetLat;
              lngAjustada += offsetLng;
            }

            return Marker(
              point: LatLng(latAjustada, lngAjustada),
              width: 40,
              height: 40,
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provincia.isNotEmpty ? '$playa ($provincia)' : playa,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (urlImagen != null && urlImagen.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      urlImagen,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.bug_report, size: 40),
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('🪼 Medusa: $medusa'),
                                    Text('📊 Cantidad: $nivel'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }).where((m) => m.point.latitude != 0.0 && m.point.longitude != 0.0).toList();

          if (marcadores.isEmpty) {
            return const Center(
              child: Text('No hay reportes de medusas registrados.'),
            );
          }

          final LatLng centroMapa = marcadores.first.point;

          return FlutterMap(
            options: MapOptions(
              initialCenter: centroMapa,
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.meteoflutter',
              ),
              MarkerLayer(
                markers: marcadores,
              ),
            ],
          );
        },
      ),
    );
  }
}