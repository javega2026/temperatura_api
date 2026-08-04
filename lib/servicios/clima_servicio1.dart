import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meteoflutter/models/clima_modelo1.dart';

class ClimaServicio1 {
  final Dio _dio = Dio();
  final String _apiKey = 'ce8b44e192207db912650d732dacde59';

  Future<ClimaModelo1?> obtenerClimaPorCiudad(String ciudad) async {
    try {
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
