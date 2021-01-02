import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService{
  User user;

  UserService(user){
    this.user=user;
  }

  getImage() {
  if (user.isAnonymous) {
    return AssetImage('assets/images/anonymous.png');
  } else {
    return NetworkImage(user.photoURL);
  }
}

String getNombre() {
  if (user.isAnonymous) {
    return 'anónimo';
  } else {
    return user.displayName;
  }
}

String getEmail() {
  if (user.isAnonymous) {
    return 'anónimo';
  } else {
    return user.email;
  }
}
String getUID() {
  return user.uid;
}
}