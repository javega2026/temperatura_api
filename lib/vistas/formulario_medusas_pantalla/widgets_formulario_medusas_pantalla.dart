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

  Color _obtenerColorNivel(String nivel) {
    switch (nivel) {
      case '1 - 5':
        return Colors.green;
      case '6 - 15':
        return Colors.orange;
      case 'Más de 15':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
        Row(
          children: opciones.map((opcion) {
            final isSelected = nivelSeleccionado == opcion;
            final colorBase = _obtenerColorNivel(opcion);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => onNivelChanged(opcion),
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? colorBase : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? colorBase : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      opcion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
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
      stream: FirebaseFirestore.instance
          .collection('reportes_medusas')
          .snapshots(),
      builder: (context, snapshot) {
        String totalTexto = '...';
        if (snapshot.hasData) {
          totalTexto = '${snapshot.data!.docs.length}';
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaListaReportes(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.list, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    totalTexto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}