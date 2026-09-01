import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IaServicio {
  final Dio _dio = Dio();

  Future<String> obtenerAnalisisMedusas() async {
    try {
      final String? apiKey = dotenv.env['GROQ_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        return "Error de configuración: La clave GROQ_API_KEY no está definida en el archivo .env";
      }
      
      // Modelo exacto obtenido del Playground de tu cuenta
      const String modeloActual = 'openai/gpt-oss-120b'; 

      debugPrint('--- DEPURACIÓN GROQ ---');
      debugPrint('Modelo utilizado: $modeloActual');

      final String fechaHoraActual = DateTime.now().toString().split('.')[0];

      final prompt = "Proporciona una guía general y útil sobre la situación de las medusas en las costas de Málaga, "
          "qué tipos suelen aparecer, qué hacer en caso de picadura y cómo está el estado general de baño. "
          "Incluye al principio del texto que este informe ha sido generado en la fecha y hora: $fechaHoraActual.";

      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        data: {
          'model': modeloActual,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['choices'][0]['message']['content'] ?? 'Sin respuesta de la IA.';
      } else {
        return "Error en la respuesta del servidor.";
      }

    } catch (e) {
      debugPrint('Error capturado en Dio: $e');
      if (e is DioException && e.response != null) {
        debugPrint('--- DATOS DEL ERROR DEL SERVIDOR ---');
        debugPrint('Data: ${e.response?.data}');
      }
      return "Error al conectar con la IA de Groq: $e";
    }
  }
}