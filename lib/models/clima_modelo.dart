class ClimaModelo {
  final String nombreCiudad;
  final String pais;
  final double temperatura;
  final double sensTermica;
  final double tempMin;
  final double tempMax;
  final String descripcion;
  final int humedad;
  final double viento;
  final int presion;

  ClimaModelo({
    required this.nombreCiudad,
    required this.pais,
    required this.temperatura,
    required this.sensTermica,
    required this.tempMin,
    required this.tempMax,
    required this.descripcion,
    required this.humedad,
    required this.viento,
    required this.presion,
  });

  factory ClimaModelo.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List<dynamic>? ?? []).isNotEmpty 
        ? json['weather'][0] 
        : {};
    final wind = json['wind'] ?? {};
    final sys = json['sys'] ?? {};

    return ClimaModelo(
      nombreCiudad: json['name'] ?? 'Desconocida',
      pais: sys['country'] ?? '',
      temperatura: (main['temp'] as num?)?.toDouble() ?? 0.0,
      sensTermica: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      descripcion: weather['description'] ?? 'Sin descripción',
      humedad: main['humidity'] ?? 0,
      viento: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      presion: main['pressure'] ?? 0,
    );
  }
}