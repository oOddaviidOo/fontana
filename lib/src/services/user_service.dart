import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserService {
  User user;
  String nombre;
  String email;
  String uid;
  dynamic imagen;
  UserService(user) {
    this.user = user;
  }

  getImage() {
    if (user.isAnonymous) {
      this.imagen = AssetImage('assets/images/anonymous.png');
      return this.imagen;
    } else {
      this.imagen = NetworkImage(user.photoURL);
      return this.imagen;
    }
  }

  String getNombre() {
    if (user.isAnonymous) {
      this.nombre = 'anónimo';
      return this.nombre;
    } else {
      this.nombre = user.displayName;
      return this.nombre;
    }
  }

  String getEmail() {
    if (user.isAnonymous) {
      this.email = 'anónimo';
      return this.email;
    } else {
      this.email = user.email;
      return this.email;
    }
  }

  String getUID() {
    this.uid = user.uid;
    return this.uid;
  }
}
