import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meteoflutter/vistas/pantalla_lista_reportes/pantalla_lista_reportes.dart';

class WidgetSelectorNivelMedusas extends StatelessWidget {
  final String nivelSeleccionado;
  final List<String> opciones;
  final ValueChanged<String> onNivelChanged;

  const WidgetSelectorNivelMedusas({
    super.key,
    required this.nivelSeleccionado,
    required this.opciones,
    required this.onNivelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nivel de medusas:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start,
          children: opciones.map((opcion) {
            return ChoiceChip(
              label: Text(opcion),
              selected: nivelSeleccionado == opcion,
              onSelected: (selected) {
                if (selected) {
                  onNivelChanged(opcion);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BotonContadorReportes extends StatelessWidget {
  const BotonContadorReportes({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reportes_medusas').snapshots(),
      builder: (context, snapshot) {
        int totalReportes = 0;
        if (snapshot.hasData) {
          totalReportes = snapshot.data!.docs.length;
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaListaReportes(),
                ),
              );
            },
            icon: const Icon(Icons.list, color: Colors.white),
            label: Text(
              '$totalReportes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}