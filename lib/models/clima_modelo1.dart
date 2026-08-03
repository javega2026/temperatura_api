class ClimaModelo1 {
  final String nombreCiudad;
  final double temperatura;
  final double sensTermica;
  final int humedad;

  ClimaModelo1({
    required this.nombreCiudad,
    required this.temperatura,
    required this.sensTermica,
    required this.humedad,
  });

  factory ClimaModelo1.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};

    return ClimaModelo1(
      nombreCiudad: json['name'] ?? 'Desconocido',
      temperatura: (main['temp'] as num?)?.toDouble() ?? 0.0,
      sensTermica: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humedad: main['humidity'] ?? 0,
    );
  }
}
