import 'dart:convert';

class ProvinciaCostera {
  final String nombre;
  final List<String> alias;

  const ProvinciaCostera({
    required this.nombre,
    this.alias = const [],
  });

  factory ProvinciaCostera.fromMap(Map<String, dynamic> map) {
    return ProvinciaCostera(
      nombre: map['nombre'] ?? '',
      alias: List<String>.from(map['alias'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'alias': alias,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProvinciaCostera.fromJson(String source) =>
      ProvinciaCostera.fromMap(json.decode(source));

  @override
  String toString() => nombre;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProvinciaCostera && other.nombre == nombre;
  }

  @override
  int get hashCode => nombre.hashCode;
}

final List<ProvinciaCostera> provinciasCosterasEspana = const [
  ProvinciaCostera(nombre: 'A Coruña', alias: ['A Coruna', 'Coruña', 'Coruna']),
  ProvinciaCostera(nombre: 'Alicante', alias: ['Alacant']),
  ProvinciaCostera(nombre: 'Almería', alias: ['Almeria']),
  ProvinciaCostera(nombre: 'Asturias', alias: ['Principality of Asturias', 'Principado de Asturias', 'Asturies']),
  ProvinciaCostera(nombre: 'Baleares', alias: ['Balearic Islands', 'Illes Balears', 'Islas Baleares']),
  ProvinciaCostera(nombre: 'Barcelona'),
  ProvinciaCostera(nombre: 'Bizkaia', alias: ['Biscay', 'Vizcaya']),
  ProvinciaCostera(nombre: 'Cádiz', alias: ['Cadiz']),
  ProvinciaCostera(nombre: 'Cantabria'),
  ProvinciaCostera(nombre: 'Castellón', alias: ['Castellon', 'Castelló']),
  ProvinciaCostera(nombre: 'Ceuta'),
  ProvinciaCostera(nombre: 'Gipuzkoa', alias: ['Guipúzcoa', 'Guipuzcoa']),
  ProvinciaCostera(nombre: 'Girona', alias: ['Gerona']),
  ProvinciaCostera(nombre: 'Huelva'),
  ProvinciaCostera(nombre: 'Las Palmas', alias: ['Gran Canaria']),
  ProvinciaCostera(nombre: 'Lugo'),
  ProvinciaCostera(nombre: 'Málaga', alias: ['Malaga']),
  ProvinciaCostera(nombre: 'Melilla'),
  ProvinciaCostera(nombre: 'Murcia', alias: ['Región de Murcia']),
  ProvinciaCostera(nombre: 'Pontevedra'),
  ProvinciaCostera(nombre: 'Santa Cruz de Tenerife', alias: ['Tenerife']),
  ProvinciaCostera(nombre: 'Tarragona'),
  ProvinciaCostera(nombre: 'Valencia', alias: ['València']),
];