import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Fontana/src/services/user_service.dart';
import 'package:provider/provider.dart';
import '../log_in_state.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  User user;
  UserService _userService;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoginState>(context, listen: false).user.user;
    _userService = new UserService(user);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fontana'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: _userService.getImage(),
              radius: 85,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Nombre: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: _userService.getNombre(),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Email: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: _userService.getEmail(),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
