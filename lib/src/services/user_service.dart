import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    if (getProvider() == "google.com") {
      this.imagen = NetworkImage(user.photoURL);
      return this.imagen;
    } else {
      if (user.isAnonymous) {
        this.imagen = AssetImage('assets/images/anonymous.png');
      }
      this.imagen = AssetImage('assets/images/user.png');
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

  String getProvider() {
    String provider = user.providerData[0].providerId;
    return provider;
  }
}
