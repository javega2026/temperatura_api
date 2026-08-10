class ClimaGraficoModelo {
  final List<String> tiempos;
  final List<double> temperaturasMax;
  final List<double> temperaturasMin;

  ClimaGraficoModelo({
    required this.tiempos,
    required this.temperaturasMax,
    required this.temperaturasMin,
  });

  factory ClimaGraficoModelo.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] ?? {};

    // Convertimos las listas dinámicas a listas de String
    return ClimaGraficoModelo(
      tiempos: List<String>.from(daily['time'] ?? []),
      temperaturasMax:
          (daily['temperature_2m_max'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      temperaturasMin:
          (daily['temperature_2m_min'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}
