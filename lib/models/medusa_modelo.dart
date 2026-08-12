class MedusaModelo {
  final String id;
  final String nombre;
  final String nombreCientifico;
  final String url;
  final String descripcion;

  MedusaModelo({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.url,
    required this.descripcion,
  });

  // Convertir un documento de Firestore a un objeto MedusaModelo
  factory MedusaModelo.fromFirestore(Map<String, dynamic> json, String docId) {
    return MedusaModelo(
      id: docId,
      nombre: json['nombre'] ?? '',
      nombreCientifico: json['nombreCientifico'] ?? '',
      url: json['url'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  // Convertir el modelo a un mapa para guardarlo en Firestore (si lo necesitas)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'nombreCientifico': nombreCientifico,
      'url': url,
      'descripcion': descripcion,
    };
  }
}