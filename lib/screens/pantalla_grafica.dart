import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meteoflutter/models/clima_grafico_modelo.dart';
import 'package:meteoflutter/servicios/clima_grafico_servicio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
 
 // 2. Añadimos el registro de Analytics aquí mismo
    FirebaseAnalytics.instance.logEvent(
      name: "pantalla_grafica_abierta",
      parameters: {
        "pantalla": "grafica",
      },
    );
 
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

          final spotsMax = _crearSpots(climaGrafico.temperaturasMax);
          final spotsMin = _crearSpots(climaGrafico.temperaturasMin);

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
                    _buildLineChartData(spotsMax, spotsMin, climaGrafico.tiempos),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLeyenda(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Convierte listas de números en puntos (FlSpot) para la gráfica
  List<FlSpot> _crearSpots(List<double> temperaturas) {
    List<FlSpot> spots = [];
    for (int i = 0; i < temperaturas.length; i++) {
      spots.add(FlSpot(i.toDouble(), temperaturas[i]));
    }
    return spots;
  }

  // Configuración principal del gráfico de líneas
  LineChartData _buildLineChartData(
      List<FlSpot> spotsMax, List<FlSpot> spotsMin, List<String> tiempos) {
    return LineChartData(
      minY: 18.0,
      maxY: 42.0,
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineTouchData: _buildLineTouchData(),
      titlesData: _buildTitlesData(tiempos),
      lineBarsData: [
        _buildLineBarData(spotsMax, Colors.redAccent),
        _buildLineBarData(spotsMin, Colors.blueAccent),
      ],
    );
  }

  // Configuración de la barra (línea) individual de la gráfica
  LineChartBarData _buildLineBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.1),
      ),
    );
  }

  // Configuración de los tooltips (cuadros flotantes al tocar un punto)
  LineTouchData _buildLineTouchData() {
    return LineTouchData(
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
    );
  }

  // Configuración de los títulos y ejes (izquierdo e inferior)
  FlTitlesData _buildTitlesData(List<String> tiempos) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < tiempos.length) {
              String fechaCompleta = tiempos[index];
              String corto = fechaCompleta.length >= 10
                  ? fechaCompleta.substring(5)
                  : fechaCompleta;
              return Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  corto,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
    );
  }

  // Widget inferior de leyenda de colores
  Widget _buildLeyenda() {
    return Row(
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
    );
  }
}