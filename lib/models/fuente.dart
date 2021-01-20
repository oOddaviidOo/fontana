import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Fuente {
  static int n_fuentes = 0;
  String nombre = "";
  String descripcion = "";
  String estado;
  double latitud;
  double longitud;
  String creada_por;
  int id;
  String get getNombre => nombre;

  set setNombre(String nombre) => this.nombre = nombre;

  String get getDescripcion => descripcion;

  set setDescripcion(String descripcion) => this.descripcion = descripcion;

  String get getEstado => estado;

  set setEstado(String estado) => this.estado = estado;

  double get getLatitud => latitud;

  set setLatitud(double latitud) => this.latitud = latitud;

  double get getLongitud => longitud;

  set setLongitud(double longitud) => this.longitud = longitud;

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
            this.latitud.toString() +
            ", " +
            this.longitud.toString() +
            "\nEstado: " +
            this.estado +
            "\nID: " +
            this.id.toString() +
            "\nCreada por: " +
            this.creada_por +
            "\nNumero de fuentes creadas:" +
            n_fuentes.toString(),
        toastLength: Toast.LENGTH_LONG);
  }

  Fuente(String n, String d, double la, double lo, User u) {
    this.nombre = n;
    this.descripcion = d;
    this.estado = "Pendiente de verificación";
    this.latitud = la;
    this.longitud = lo;
    this.id = n_fuentes + 1;
    this.creada_por = u.displayName;
    n_fuentes++;
  }
}
