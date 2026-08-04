import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_grafico_modelo.dart';
import 'package:meteoflutter/servicios/clima_grafico_servicio.dart';

class PantallaGrafica extends StatefulWidget {
  final double latitud;
  final double longitud;
  final String nombreCiudad;

  const PantallaGrafica({
    super.key,
    required this.latitud,
    required this.longitud,
    required this.nombreCiudad,
  });

  @override
  State<PantallaGrafica> createState() => _PantallaGraficaState();
}

class _PantallaGraficaState extends State<PantallaGrafica> {
  final ClimaGraficoServicio _servicio = ClimaGraficoServicio();
  late Future<ClimaGraficoModelo?> _futuroClimaGrafico;

  @override
  void initState() {
    super.initState();
    _futuroClimaGrafico = _servicio.obtenerDatosGrafica(widget.latitud, widget.longitud);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica de Temp. ${widget.nombreCiudad}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<ClimaGraficoModelo?>(
        future: _futuroClimaGrafico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error al cargar los datos de la gráfica'));
          }

          final climaGrafico = snapshot.data!;

          if (climaGrafico.tiempos.isEmpty) {
            return const Center(child: Text('La lista de días está vacía'));
          }

          // Convertimos las temperaturas máximas en puntos (FlSpot) para la gráfica
          final List<FlSpot> spotsMax = [];
          for (int i = 0; i < climaGrafico.temperaturasMax.length; i++) {
            spotsMax.add(FlSpot(i.toDouble(), climaGrafico.temperaturasMax[i]));
          }

          // Convertimos las temperaturas mínimas en puntos (FlSpot) para la gráfica
          final List<FlSpot> spotsMin = [];
          for (int i = 0; i < climaGrafico.temperaturasMin.length; i++) {
            spotsMin.add(FlSpot(i.toDouble(), climaGrafico.temperaturasMin[i]));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Evolución de Temperaturas (Últimos días)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: 18.0, 
                      maxY: 42,
                      gridData: const FlGridData(show: true),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800,
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              final textStyle = TextStyle(
                                color: spot.bar.color ?? Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              );
                              return LineTooltipItem(
                                '${spot.y.toStringAsFixed(1)}°', 
                                textStyle,
                              );
                            }).toList();
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}°',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30, // Damos algo de espacio vertical abajo
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < climaGrafico.tiempos.length) {
                                String fechaCompleta = climaGrafico.tiempos[index];
                                String corto = fechaCompleta.length >= 10 
                                    ? fechaCompleta.substring(5) 
                                    : fechaCompleta;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    corto, 
                                    style: const TextStyle(
                                      fontSize: 11, // <-- Reducido de 14 a 11 para que no se solapen
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spotsMax,
                          isCurved: true,
                          color: Colors.redAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.redAccent.withValues(alpha: 0.1),
                          ),
                        ),
                        LineChartBarData(
                          spots: spotsMin,
                          isCurved: true,
                          color: Colors.blueAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blueAccent.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.circle, color: Colors.redAccent, size: 14),
                    SizedBox(width: 4),
                    Text('Máxima (°C)'),
                    SizedBox(width: 20),
                    Icon(Icons.circle, color: Colors.blueAccent, size: 14),
                    SizedBox(width: 4),
                    Text('Mínima (°C)'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}