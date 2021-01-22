// To parse this JSON data, do
//
//     final peticion = peticionFromJson(jsonString);

import 'dart:convert';

Peticion peticionFromJson(String str) => Peticion.fromJson(json.decode(str));

String peticionToJson(Peticion data) => json.encode(data.toJson());

class Peticion {
  Peticion({
    this.id,
    this.idFuente,
    this.descripcion,
    this.tipo,
    this.votospos,
    this.votosneg,
    this.usuario,
  });

  String id;
  String idFuente;
  String descripcion;
  String tipo;
  int votospos;
  int votosneg;
  String usuario;

  factory Peticion.fromJson(Map<String, dynamic> json) => Peticion(
        id: json["id"],
        idFuente: json["idFuente"],
        descripcion: json["descripcion"],
        tipo: json["tipo"],
        votospos: json["votospos"],
        votosneg: json["votosneg"],
        usuario: json["usuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idFuente": idFuente,
        "descripcion": descripcion,
        "tipo": tipo,
        "votospos": votospos,
        "votosneg": votosneg,
        "usuario": usuario,
      };
}
