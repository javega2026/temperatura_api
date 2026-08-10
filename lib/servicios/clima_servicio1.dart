import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';

class ClimaServicio1 {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<ClimaModelo1?> obtenerClimaPorCiudad(String ciudad) async {
    try {
      if (_apiKey.isEmpty) {
        debugPrint(
          'Error: La API Key de OpenWeather no está configurada en el .env',
        );
        return null;
      }

      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$ciudad,es&units=metric&appid=$_apiKey';

      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return ClimaModelo1.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error al obtener el clima: $e');
      return null;
    }
  }
}
