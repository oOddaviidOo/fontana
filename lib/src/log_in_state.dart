import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential user;
  bool _loggedIn = false;
  bool _loading = false;

  bool isLoggedIn() {
    return _loggedIn;
  }

  bool isLoading() {
    return _loading;
  }

  void loginGoogle() async {
    _loading = true;
    notifyListeners();

    user = await _handleGoogleSignIn();

    _loading = false;
    if (user != null) {
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logoutGoogle() async {
    _loggedIn = false;
    _googleSignIn.signOut();
    notifyListeners();
  }

  void loginAnonymous() async {
    //El user no es null pero sus propiedades serán null
    user = await signInAnonymous();
    if (user != null) {
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logoutAnonymous() async {
    _loggedIn = false;
    _auth.signOut();
    notifyListeners();
  }

  Future<UserCredential> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential user = await _auth.signInWithCredential(credential);
    
    return user;
    /*final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final User user = (await _auth.signInWithCredential(credential)) as User;
    print("Sesion iniciada " + user.displayName);
    return user;*/
  }

  Future<UserCredential> signInAnonymous() async {
    UserCredential user = await _auth.signInAnonymously();
    return user;
    /*
    try {
      var result = await _auth.signInAnonymously();
      User user = result.user;
      print("Sesion anonima");
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }*/
  }
}
