class PlayaModelo {
  final String id;
  final String nombre;

  PlayaModelo({required this.id, required this.nombre});
}

// --- ARRAY COMPLETO CON LAS 15 PLAYAS DE MÁLAGA CAPITAL ---
// ignore: unused_element
final List<PlayaModelo> _playasMalaga = [
  PlayaModelo(id: 'guadalmar', nombre: 'Playa de Guadalmar'),
  PlayaModelo(id: 'san_andres', nombre: 'Playa de San Andrés'),
  PlayaModelo(id: 'misericordia', nombre: 'Playa de La Misericordia'),
  PlayaModelo(id: 'sacaba', nombre: 'Playa de Sacaba Beach'),
  PlayaModelo(id: 'malagueta', nombre: 'Playa de La Malagueta'),
  PlayaModelo(id: 'caleta', nombre: 'Playa de La Caleta'),
  PlayaModelo(id: 'banos_carmen', nombre: 'Baños del Carmen'),
  PlayaModelo(id: 'pedregalejo', nombre: 'Playa de Pedregalejo'),
  PlayaModelo(id: 'el_palo', nombre: 'Playa de El Palo'),
  PlayaModelo(id: 'el_dedo', nombre: 'Playa del Dedo'),
  PlayaModelo(id: 'candado', nombre: 'Playa de El Candado'),
  PlayaModelo(id: 'penon_cuervo', nombre: 'Playa del Peñón del Cuervo'),
  PlayaModelo(id: 'fabrica_cemento', nombre: 'Playa de la Fábrica de Cemento'),
  PlayaModelo(id: 'arana', nombre: 'Playa de la Araña'),
  PlayaModelo(id: 'guadalhorce', nombre: 'Playa del Guadalhorce'),
];


//https://api.openweathermap.org/data/2.5/weather?q=Madrid,es&units=metric&appid=ce8b44e192207db912650d732dacde59

//https://api.open-meteo.com/v1/forecast?latitude=36.7202&longitude=-4.4203&daily=temperature_2m_max,temperature_2m_min&past_days=7&timezone=Europe/Berlin