import 'package:flutter/material.dart';
import 'package:meteoflutter/models/reporte_medusa_modelo.dart';


//Un StatelessWidget es un bloque de construcción visual en Flutter 
//diseñado para crear componentes estáticos, es decir, 
//elementos cuya apariencia no cambia por sí misma una 
//vez que se dibujan en la pantalla.
class CardReporte extends StatelessWidget {
  final ReporteMedusaModelo reporte;
  final String tiempoRestante;

  const CardReporte({
    super.key,
    required this.reporte,
    required this.tiempoRestante,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: reporte.imagen.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    reporte.imagen,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                )
              : const Icon(Icons.warning, size: 40, color: Colors.orange),
          title: Text(
            '${reporte.nombreComun} (${reporte.nombreEspecifico})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('🏖️ Playa: ${reporte.playa}'),
              Text('📊 Nivel: ${reporte.nivelMedusas}'),
              Text('📍 Provincia: ${reporte.provincia}'),
              Text('📅 Fecha: ${reporte.fechaHora}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Se borra en:',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
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
  }
}