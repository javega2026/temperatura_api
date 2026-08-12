class PlayaModelo {
  final String id;
  final String nombre;
  final double latitud;
  final double longitud;

  PlayaModelo({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

// --- ARRAY COMPLETO AMPLIADO DE PLAYAS DE MÁLAGA CAPITAL ---
final List<PlayaModelo> playasMalaga = [
  PlayaModelo(
    id: 'guadalhorce',
    nombre: 'Playa del Guadalhorce',
    latitud: 36.6789,
    longitud: -4.4712,
  ),
  PlayaModelo(
    id: 'guadalmar',
    nombre: 'Playa de Guadalmar',
    latitud: 36.6692,
    longitud: -4.4735,
  ),
  PlayaModelo(
    id: 'sacaba',
    nombre: 'Playa de Sacaba Beach',
    latitud: 36.6851,
    longitud: -4.4654,
  ),
  PlayaModelo(
    id: 'misericordia',
    nombre: 'Playa de La Misericordia',
    latitud: 36.6945,
    longitud: -4.4587,
  ),
  PlayaModelo(
    id: 'huelin',
    nombre: 'Playa de Huelin',
    latitud: 36.7032,
    longitud: -4.4454,
  ),
  PlayaModelo(
    id: 'san_andres',
    nombre: 'Playa de San Andrés',
    latitud: 36.7089,
    longitud: -4.4372,
  ),
  PlayaModelo(
    id: 'malagueta',
    nombre: 'Playa de La Malagueta',
    latitud: 36.7213,
    longitud: -4.4101,
  ),
  PlayaModelo(
    id: 'caleta',
    nombre: 'Playa de La Caleta',
    latitud: 36.7208,
    longitud: -4.3975,
  ),
  PlayaModelo(
    id: 'banos_carmen',
    nombre: 'Baños del Carmen',
    latitud: 36.7187,
    longitud: -4.3812,
  ),
  PlayaModelo(
    id: 'pedregalejo',
    nombre: 'Playa de Pedregalejo',
    latitud: 36.7165,
    longitud: -4.3687,
  ),
  PlayaModelo(
    id: 'el_palo',
    nombre: 'Playa de El Palo',
    latitud: 36.7143,
    longitud: -4.3543,
  ),
  PlayaModelo(
    id: 'el_dedo',
    nombre: 'Playa del Dedo (El Chanquete)',
    latitud: 36.7121,
    longitud: -4.3412,
  ),
  PlayaModelo(
    id: 'candado',
    nombre: 'Playa de El Candado',
    latitud: 36.7110,
    longitud: -4.3315,
  ),
  PlayaModelo(
    id: 'penon_cuervo',
    nombre: 'Playa del Peñón del Cuervo',
    latitud: 36.7102,
    longitud: -4.3212,
  ),
  PlayaModelo(
    id: 'fabrica_cemento',
    nombre: 'Playa de la Fábrica de Cemento',
    latitud: 36.7095,
    longitud: -4.3123,
  ),
  PlayaModelo(
    id: 'arana',
    nombre: 'Playa de la Araña',
    latitud: 36.7087,
    longitud: -4.3054,
  ),
];