import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TemperaturaGraficoWidget extends StatelessWidget {
  const TemperaturaGraficoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    // Etiquetas de los días (ejemplo numérico o fechas simplificadas)
                    switch (value.toInt()) {
                      case 0: return const Text('D 1', style: TextStyle(fontSize: 10));
                      case 3: return const Text('D 4', style: TextStyle(fontSize: 10));
                      case 6: return const Text('D 7', style: TextStyle(fontSize: 10));
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              // Línea de Temperatura Máxima (Rojo)
              LineChartBarData(
                spots: const [
                  FlSpot(0, 34.0),
                  FlSpot(1, 37.2),
                  FlSpot(2, 37.7),
                  FlSpot(3, 38.0),
                  FlSpot(4, 37.2),
                  FlSpot(5, 37.9),
                  FlSpot(6, 35.9),
                ],
                isCurved: true,
                color: Colors.red,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
              // Línea de Temperatura Mínima (Azul)
              LineChartBarData(
                spots: const [
                  FlSpot(0, 19.0),
                  FlSpot(1, 20.4),
                  FlSpot(2, 23.1),
                  FlSpot(3, 23.8),
                  FlSpot(4, 24.9),
                  FlSpot(5, 21.0),
                  FlSpot(6, 22.5),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}