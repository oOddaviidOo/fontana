import 'package:flutter/material.dart';

class LoginState with ChangeNotifier{
  bool _loggedIn = false;
  bool isLoggedIn(){
    return _loggedIn;
  }
  
  void login(){
    _loggedIn = true;
    notifyListeners();
  }

    void logout(){
    _loggedIn = false;
    notifyListeners();
  }
}