import 'package:flutter/material.dart';
import 'package:meteoflutter/models/playa_lon_lat_modelo.dart';

class WidgetSelectorPlaya extends StatelessWidget {
  final String? playaIdSeleccionada;
  final ValueChanged<String?> onPlayaSelected;

  const WidgetSelectorPlaya({
    super.key,
    required this.playaIdSeleccionada,
    required this.onPlayaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la playa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownMenu<String>(
          initialSelection: playaIdSeleccionada,
          hintText: 'Elige una playa',
          width: double.infinity,
          leadingIcon: const Icon(Icons.beach_access, color: Colors.blueAccent),
          dropdownMenuEntries: playasMalaga.map((playa) {
            return DropdownMenuEntry<String>(
              value: playa.id,
              label: playa.nombre,
            );
          }).toList(),
          onSelected: onPlayaSelected,
        ),
      ],
    );
  }
}