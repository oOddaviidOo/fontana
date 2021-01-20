import 'package:geolocator/geolocator.dart';

class LocationService {
  String latitud;
  String longitud;

  LocationService(Position p) {
    this.latitud = p.latitude as String;
    this.longitud = p.longitude as String;
  }
  String getLatitud() {
    return this.latitud;
  }

  String getLongitud() {
    return this.latitud;
  }
}
