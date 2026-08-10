import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IaServicio {
  final Dio _dio = Dio();

  Future<String> obtenerAnalisisMedusas() async {
    try {
      // Leemos la clave exclusivamente desde las variables de entorno
      final String? apiKey = dotenv.env['GROQ_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        return "Error de configuración: La clave GROQ_API_KEY no está definida en el archivo .env";
      }

      // Obtenemos la fecha y hora actual para incluirla en el prompt
      final String fechaHoraActual = DateTime.now().toString().split('.')[0];

      final prompt = "Proporciona una guía general y útil sobre la situación de las medusas en las costas de Málaga, "
          "qué tipos suelen aparecer, qué hacer en caso de picadura y cómo está el estado general de baño. "
          "Incluye al principio del texto que este informe ha sido generado en la fecha y hora: $fechaHoraActual.";

      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        data: {
          'model': 'llama-3.3-70b-versatile',
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
      return "Error al conectar con la IA de Groq: $e";
    }
  }
}