class UsuarioModelo {
  final String nombre;
  final String email;
  final String rol;
  final String fechaRegistro;

  UsuarioModelo({
    required this.nombre,
    required this.email,
    required this.rol,
    required this.fechaRegistro,
  });

  // Leer desde Firestore
  factory UsuarioModelo.fromMap(Map<String, dynamic> map, String id) {
    return UsuarioModelo(
     
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'usuario',
      fechaRegistro: map['fechaRegistro'] ?? '',
    );
  }

  // Guardar en Firestore (no guardamos el uid dentro del mapa porque ya es el ID del documento)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'fechaRegistro': fechaRegistro,
    };
  }
}
