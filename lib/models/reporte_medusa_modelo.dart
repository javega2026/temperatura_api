class ReporteMedusaModelo {
  final String? id; // Opcional, por si guardas el ID del documento de Firestore
  final String nombreComun;
  final String nombreEspecifico;
  final String imagen;
  final String playa;
  final String provincia;
  final String nivelMedusas;
  final String fechaHora;
  final double latitud;
  final double longitud;

  ReporteMedusaModelo({
    this.id,
    required this.nombreComun,
    required this.nombreEspecifico,
    required this.imagen,
    required this.playa,
    required this.provincia,
    required this.nivelMedusas,
    required this.fechaHora,
    required this.latitud,
    required this.longitud,
  });

  // 📌 Método para convertir de Map/Firestore a Objeto
  factory ReporteMedusaModelo.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ReporteMedusaModelo(
      id: documentId,
      nombreComun: data['nombre_comun'] ?? '',
      nombreEspecifico: data['nombre_especifico'] ?? '',
      imagen: data['imagen'] ?? '',
      playa: data['playa'] ?? '',
      provincia: data['provincia'] ?? '',
      nivelMedusas: data['nivel_medusas'] ?? '',
      fechaHora: data['fecha_hora'] ?? '',
      latitud: (data['latitud'] ?? 0.0).toDouble(),
      longitud: (data['longitud'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre_comun': nombreComun,
      'nombre_especifico': nombreEspecifico,
      'imagen': imagen,
      'playa': playa,
      'provincia': provincia,
      'nivel_medusas': nivelMedusas,
      'fecha_hora': fechaHora,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}