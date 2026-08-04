class ClimaModelo1 {
  final String nombreCiudad;
  final double temperatura;
  final double sensTermica;
  final int humedad;
  final double vientoVelocidad;
  final double presion;
  final double lat;
  final double lon;

  ClimaModelo1({
    required this.nombreCiudad,
    required this.temperatura,
    required this.sensTermica,
    required this.humedad,
    required this.vientoVelocidad,
    required this.presion,
    required this.lat,
    required this.lon,
  });

  factory ClimaModelo1.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final coord = json['coord'] ?? {};
    final wind = json['wind'] ?? {};
    
    return ClimaModelo1(
      nombreCiudad: json['name'] ?? 'Desconocida',
      temperatura: (main['temp'] as num?)?.toDouble() ?? 0.0,
      sensTermica: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humedad: main['humidity'] ?? 0,
      lat: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (coord['lon'] as num?)?.toDouble() ?? 0.0,
      vientoVelocidad: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      presion: (main['pressure'] as num?)?.toDouble() ?? 0.0,
    );
  }
}