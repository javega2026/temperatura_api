import 'package:dio/dio.dart';
import 'package:meteoflutter/models/clima_grafico_modelo.dart';

class ClimaGraficoServicio {
  final Dio _dio = Dio();

  // Se recibe latitud y longitud
  Future<ClimaGraficoModelo?> obtenerDatosGrafica(double lat, double lon) async {
    try {
      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min&past_days=7&timezone=Europe/Berlin';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return ClimaGraficoModelo.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error al obtener los datos de la gráfica: $e');
      return null;
    }
  }
}
