import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user;

  bool _loggedIn = false;
  bool isLoggedIn() {
    return _loggedIn;
  }

  void login() async {
    user = await _handleGoogleSignIn();
    if (user != null) {
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logout() async {
    _loggedIn = false;
    _googleSignIn.signOut();
    notifyListeners();
  }

  Future<User> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final User user = (await _auth.signInWithCredential(credential)) as User;
    print("Sesion iniciada " + user.displayName);
    return user;
  }

  Future<User> signInAnonymous() async {
    try {
      var result = await _auth.signInAnonymously();
      User user = result.user;
      print("Sesion anonima");
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
