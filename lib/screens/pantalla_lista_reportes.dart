import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';
import 'package:meteoflutter/widgets/usuario_guarda_medusa/_CardReporte.dart';

class PantallaListaReportes extends StatefulWidget {
  const PantallaListaReportes({super.key});

  @override
  State<PantallaListaReportes> createState() => _PantallaListaReportesState();
}

class _PantallaListaReportesState extends State<PantallaListaReportes> {
  static const int tiempoExpiracionMinutos = 1179;

  @override
  void initState() {
    super.initState();
    _eliminarReportesExpiradosDeFirestore();
  }

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

          final fechaCreacion = DateTime(
            int.parse(fechaPartes[2]),
            int.parse(fechaPartes[1]),
            int.parse(fechaPartes[0]),
            int.parse(horaPartes[0]),
            int.parse(horaPartes[1]),
          );
          
          final fechaExpiracion = fechaCreacion.add(const Duration(minutes: tiempoExpiracionMinutos));

          if (fechaExpiracion.isBefore(ahora)) {
            await FirebaseFirestore.instance.collection('reportes_medusas').doc(doc.id).delete();
          }
        }
      }
    } catch (e) {
      debugPrint("Error al limpiar reportes antiguos: $e");
    }
  }

  String _calcularTiempoRestante(String fechaStr) {
    try {
      final partes = fechaStr.split(' - ');
      final fechaPartes = partes[0].split('/');
      final horaPartes = partes[1].split(':');

      final fechaCreacion = DateTime(
        int.parse(fechaPartes[2]),
        int.parse(fechaPartes[1]),
        int.parse(fechaPartes[0]),
        int.parse(horaPartes[0]),
        int.parse(horaPartes[1]),
      );
      
      final fechaExpiracion = fechaCreacion.add(const Duration(minutes: tiempoExpiracionMinutos));
      final diferencia = fechaExpiracion.difference(DateTime.now());

      if (diferencia.isNegative) return 'Expirando...';

      final horas = diferencia.inHours;
      final minutos = diferencia.inMinutes % 60;
      final segundos = diferencia.inSeconds % 60;

      return horas > 0 ? '${horas}h ${minutos}m' : '${minutos}m ${segundos}s';
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
        stream: FirebaseFirestore.instance.collection('reportes_medusas').snapshots(),
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

              // Convertimos el documento utilizando tu Modelo
              final reporte = ReporteMedusaModelo.fromFirestore(data, doc.id);
              final tiempoRestante = _calcularTiempoRestante(reporte.fechaHora);

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