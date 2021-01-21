// To parse this JSON data, do
//
//     final fuente = fuenteFromJson(jsonString);

import 'dart:convert';

Fuente fuenteFromJson(String str) => Fuente.fromJson(json.decode(str));

String fuenteToJson(Fuente data) => json.encode(data.toJson());

class Fuente {
  Fuente({
    this.id,
    this.nombre,
    this.descripcion,
    this.estado,
    this.latitud,
    this.longitud,
    this.fotoUrl,
  });

  String id;
  String nombre;
  String descripcion;
  String estado;
  double latitud;
  double longitud;
  String fotoUrl;

  factory Fuente.fromJson(Map<String, dynamic> json) => Fuente(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        estado: json["estado"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        fotoUrl: json["fotoURL"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "estado": estado,
        "latitud": latitud,
        "longitud": longitud,
        "fotoURL": fotoUrl,
      };
}
