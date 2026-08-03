class ClimaModelo1 {
  final String nombreCiudad;
  final double temperatura;
  final double sensTermica;
  final int humedad;
  final double lat; // Nueva
  final double lon; // Nueva

  ClimaModelo1({
    required this.nombreCiudad,
    required this.temperatura,
    required this.sensTermica,
    required this.humedad,
    required this.lat,
    required this.lon,
  });

  factory ClimaModelo1.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final coord = json['coord'] ?? {};

    return ClimaModelo1(
      nombreCiudad: json['name'] ?? 'Desconocida',
      temperatura: (main['temp'] as num?)?.toDouble() ?? 0.0,
      sensTermica: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humedad: main['humidity'] ?? 0,
      lat: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (coord['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}