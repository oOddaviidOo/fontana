import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Fuente {
  String nombre;
  String descripcion;
  String estado;
  String latitud;
  String longitud;
  int id;
  String get getNombre => nombre;

  set setNombre(String nombre) => this.nombre = nombre;

  String get getDescripcion => descripcion;

  set setDescripcion(String descripcion) => this.descripcion = descripcion;

  String get getEstado => estado;

  set setEstado(String estado) => this.estado = estado;

  String get getLatitud => latitud;

  set setLatitud(String latitud) => this.latitud = latitud;

  String get getLongitud => longitud;

  set setLongitud(String longitud) => this.longitud = longitud;

  int get getId => id;

  set setId(int id) => this.id = id;

  void mostrarDatos() {
    Fluttertoast.showToast(
        msg: "Fuente:" +
            "\nNombre: " +
            this.nombre +
            "\nDescripción: " +
            this.descripcion +
            "\nCoordenadas: " +
            this.latitud +
            ", " +
            this.longitud +
            "\nEstado: " +
            this.estado +
            "\nID: " +
            this.id.toString());
  }

  Fuente(String n, String d, String la, String lo, User u) {
    this.nombre = n;
    this.descripcion = d;
    this.estado = "Pendiente de verificación";
    this.latitud = la;
    this.longitud = lo;
    this.id = 2;
  }
}
