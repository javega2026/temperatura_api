class FormularioModelo {
  final String nombre;
  final int cantidad;
  final double medida;
  final String fecha;

  FormularioModelo({
    required this.nombre,
    required this.cantidad,
    required this.medida,
    required this.fecha,
  });

  // Método para convertir el objeto en un mapa compatible con Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'medida': medida,
      'fecha': fecha,
    };
  }
}
