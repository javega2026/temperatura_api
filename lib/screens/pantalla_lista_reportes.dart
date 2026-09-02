import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaListaReportes extends StatefulWidget {
  const PantallaListaReportes({super.key});

  @override
  State<PantallaListaReportes> createState() => _PantallaListaReportesState();
}

class _PantallaListaReportesState extends State<PantallaListaReportes> {
  // ⚙️ AQUÍ CONTROLAS EL TIEMPO EN MINUTOS DE FORMA GLOBAL
  // Cambia este número (ej: 2 para pruebas, 120 para 2 horas, 300 para 5 horas, etc.)
  static const int tiempoExpiracionMinutos = 2;

  @override
  void initState() {
    super.initState();
    _eliminarReportesExpiradosDeFirestore();
  }

  // 🧹 1. Borrado automático en Firestore usando la variable global
  Future<void> _eliminarReportesExpiradosDeFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('reportes_medusas').get();
      final ahora = DateTime.now();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final fechaStr = data['fecha_hora'] ?? '';

        if (fechaStr.isNotEmpty) {
          final partes = fechaStr.split(' - ');
          final fechaPartes = partes[0].split('/');
          final horaPartes = partes[1].split(':');

          final dia = int.parse(fechaPartes[0]);
          final mes = int.parse(fechaPartes[1]);
          final anio = int.parse(fechaPartes[2]);
          final hora = int.parse(horaPartes[0]);
          final minuto = int.parse(horaPartes[1]);

          final fechaCreacion = DateTime(anio, mes, dia, hora, minuto);
          
          // Se usa la variable global de minutos
          final fechaExpiracion = fechaCreacion.add(const Duration(minutes: tiempoExpiracionMinutos));

          if (fechaExpiracion.isBefore(ahora)) {
            await FirebaseFirestore.instance
                .collection('reportes_medusas')
                .doc(doc.id)
                .delete();
          }
        }
      }
    } catch (e) {
      debugPrint("Error al limpiar reportes antiguos: $e");
    }
  }

  // ⏱️ 2. Cálculo visual para la pantalla usando la misma variable global
  String _calcularTiempoRestante(String fechaStr) {
    try {
      final partes = fechaStr.split(' - ');
      final fechaPartes = partes[0].split('/');
      final horaPartes = partes[1].split(':');

      final dia = int.parse(fechaPartes[0]);
      final mes = int.parse(fechaPartes[1]);
      final anio = int.parse(fechaPartes[2]);
      final hora = int.parse(horaPartes[0]);
      final minuto = int.parse(horaPartes[1]);

      final fechaCreacion = DateTime(anio, mes, dia, hora, minuto);
      
      // Se usa la misma variable global de minutos
      final fechaExpiracion = fechaCreacion.add(const Duration(minutes: tiempoExpiracionMinutos));
      final ahora = DateTime.now();

      final diferencia = fechaExpiracion.difference(ahora);

      if (diferencia.isNegative) {
        return 'Expirando...';
      }

      final horas = diferencia.inHours;
      final minutos = diferencia.inMinutes % 60;
      final segundos = diferencia.inSeconds % 60;

      // Si pasa de 60 minutos, muestra horas y minutos; si es menor, muestra minutos y segundos
      if (horas > 0) {
        return '${horas}h ${minutos}m';
      } else {
        return '${minutos}m ${segundos}s';
      }
    } catch (e) {
      return 'Calculando...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reportes'),
        backgroundColor: Colors.teal,
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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay reportes de medusas todavía.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final nombreComun = data['nombre_comun'] ?? 'Desconocida';
              final nombreEspecifico = data['nombre_especifico'] ?? '';
              final playa = data['playa'] ?? 'Playa desconocida';
              final nivel = data['nivel_medusas'] ?? 'N/A';
              final fechaTexto = data['fecha_hora'] ?? '';
              final imagenUrl = data['imagen'] ?? '';

              final tiempoRestante = _calcularTiempoRestante(fechaTexto);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: imagenUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imagenUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          )
                        : const Icon(Icons.warning, size: 40, color: Colors.orange),
                    
                    title: Text(
                      '$nombreComun ($nombreEspecifico)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('🏖️ Playa: $playa'),
                        Text('📊 Nivel: $nivel'),
                        Text('📅 Fecha: $fechaTexto', style: const TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Se borra en:',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer, size: 14, color: Colors.redAccent),
                            const SizedBox(width: 4),
                            Text(
                              tiempoRestante,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}