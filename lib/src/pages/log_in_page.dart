import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fontana/src/log_in_state.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Consumer(
        builder: (BuildContext context, LoginState value, Widget child) {
          if (value.isLoading()) {
            return CircularProgressIndicator();
          } else {
            return child;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButtonBuilder(
              text: 'Inicio de sesión anónimo',
              icon: Icons.person,
              onPressed: () { Provider.of<LoginState>(context, listen: false)
                                  .loginAnonymous();},
              backgroundColor: Colors.grey[600],
              width: 220.0,
            ),
            Divider(),
            SignInButtonBuilder(
              text: 'Registro con email',
              icon: Icons.email,
              onPressed: () {},
              backgroundColor: Colors.blueGrey,
              width: 220.0,
            ),
            Divider(),
            SignInButtonBuilder(
              text: 'Inicio de sesión con email',
              icon: Icons.email,
              onPressed: () {},
              backgroundColor: Colors.blueGrey[700],
              width: 220.0,
            ),
            Divider(),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                Provider.of<LoginState>(context, listen: false).loginGoogle();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
