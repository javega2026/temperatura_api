import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';
import 'package:meteoflutter/vistas/lista_reportes_medusas/_card_reporte.dart';

class PantallaListaReportes extends StatefulWidget {
  const PantallaListaReportes({super.key});

  @override
  State<PantallaListaReportes> createState() => _PantallaListaReportesState();
}

class _PantallaListaReportesState extends State<PantallaListaReportes> {
  // Tiempo que tardan en desaparecer las alertas (en minutos)
  static const int tiempoExpiracionMinutos = 5179;

  @override
  void initState() {
    super.initState();
    _eliminarReportesExpiradosDeFirestore();
  }

  // Elimina de Firestore los reportes cuya fecha supere el tiempo límite
  Future<void> _eliminarReportesExpiradosDeFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reportes_medusas')
          .get();
      final ahora = DateTime.now();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final Timestamp? timestamp = data['timestamp'] as Timestamp?;

        if (timestamp != null) {
          final fechaCreacion = timestamp.toDate();
          final fechaExpiracion = fechaCreacion.add(
            const Duration(minutes: tiempoExpiracionMinutos),
          );

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

  // Calcula la cuenta atrás usando el Timestamp de Firestore
  String _calcularTiempoRestante(Timestamp? timestamp) {
    if (timestamp == null) return 'Calculando...';

    final fechaCreacion = timestamp.toDate();
    final fechaExpiracion = fechaCreacion.add(
      const Duration(minutes: tiempoExpiracionMinutos),
    );
    final diferencia = fechaExpiracion.difference(DateTime.now());

    if (diferencia.isNegative) return 'Expirando...';

    final horas = diferencia.inHours;
    final minutos = diferencia.inMinutes % 60;
    final segundos = diferencia.inSeconds % 60;

    return horas > 0 ? '${horas}h ${minutos}m' : '${minutos}m ${segundos}s';
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
        // Ordena directamente desde Firestore usando 'timestamp' descendente (más nuevo primero)
        stream: FirebaseFirestore.instance
            .collection('reportes_medusas')
            .orderBy('timestamp', descending: true)
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

              final reporte = ReporteMedusaModelo.fromFirestore(data, doc.id);
              final Timestamp? timestamp = data['timestamp'] as Timestamp?;
              final tiempoRestante = _calcularTiempoRestante(timestamp);

              return CardReporte(
                reporte: reporte,
                tiempoRestante: tiempoRestante,
              );
            },
          );
        },
      ),
    );
  }
}