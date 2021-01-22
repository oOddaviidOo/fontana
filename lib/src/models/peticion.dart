// To parse this JSON data, do
//
//     final peticion = peticionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Peticion peticionFromJson(String str) => Peticion.fromJson(json.decode(str));

String peticionToJson(Peticion data) => json.encode(data.toJson());

class Peticion {
  Peticion({
    @required this.id,
    @required this.idFuente,
    @required this.motivo,
    @required this.tipo,
    @required this.usuario,
  });

  String id;
  String idFuente;
  String motivo;
  String tipo;
  String usuario;

  factory Peticion.fromJson(Map<String, dynamic> json) => Peticion(
        id: json["id"],
        idFuente: json["idFuente"],
        motivo: json["motivo"],
        tipo: json["tipo"],
        usuario: json["usuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idFuente": idFuente,
        "motivo": motivo,
        "tipo": tipo,
        "usuario": usuario,
      };
}
