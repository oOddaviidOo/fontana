// To parse this JSON data, do
//
//     final fuente = fuenteFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Fuente fuenteFromJson(String str) => Fuente.fromJson(json.decode(str));

String fuenteToJson(Fuente data) => json.encode(data.toJson());

class Fuente {
  Fuente({
    @required this.id,
    @required this.nombre,
    @required this.descripcion,
    this.estado = "Pendiente de verificacion",
    @required this.latitud,
    @required this.longitud,
    @required this.usuario,
  });

  String id;
  String nombre;
  String descripcion;
  String estado;
  double latitud;
  double longitud;
  String usuario;

  factory Fuente.fromJson(Map<String, dynamic> json) => Fuente(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        estado: json["estado"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        usuario: json["anyadida_por"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "estado": estado,
        "latitud": latitud,
        "longitud": longitud,
        "anyadida_por": usuario,
      };
}
