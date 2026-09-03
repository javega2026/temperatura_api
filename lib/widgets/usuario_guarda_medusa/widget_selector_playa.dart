import 'package:flutter/material.dart';
import 'package:meteoflutter/models/playa_modelo1.dart';

class WidgetSelectorPlaya extends StatelessWidget {
  final String? playaIdSeleccionada;
  // Cambiamos a ValueChanged<PlayaModelo?> para pasar toda la info (id, nombre, lat, lon)
  final ValueChanged<PlayaModelo?> onPlayaSelected;

  const WidgetSelectorPlaya({
    super.key,
    required this.playaIdSeleccionada,
    required this.onPlayaSelected,
  });

  @override
  Widget build(BuildContext context) {
    PlayaModelo? playaActual;
    if (playaIdSeleccionada != null) {
      try {
        playaActual = playasAndalucia.firstWhere((p) => p.id == playaIdSeleccionada);
      } catch (_) {
        playaActual = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la playa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        Autocomplete<PlayaModelo>(
          initialValue: TextEditingValue(text: playaActual?.nombre ?? ''),
          displayStringForOption: (PlayaModelo option) => option.nombre,
          
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<PlayaModelo>.empty();
            }
            return playasAndalucia.where((playa) {
              return playa.nombre
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          
          // 📍 Aquí devolvemos el objeto entero con latitud y longitud
          onSelected: (PlayaModelo selection) {
            onPlayaSelected(selection);
          },
          
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          option.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${option.provincia} - ${option.municipio}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
          
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Escribe para buscar playa...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}