import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:Fontana/src/log_in_state.dart';
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
            RichText(
                text: TextSpan(
                    text: 'BIENVENIDO A FONTANA',
                    style: TextStyle(
                      color: Colors.lightBlueAccent[400],
                      fontSize: 30,
                      fontFamily: 'PermanentMarker'
                    ))),
            Image(
              image: AssetImage('assets/images/logo1.2.png'),
              width: 200,
            ),
            Divider(),
            RichText(
                text: TextSpan(
              text: '¿Inicia sesión para acceder a la app?',
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
            Divider(),
            SignInButtonBuilder(
              text: 'Inicio de sesión anónimo',
              icon: Icons.person,
              onPressed: () {
                Provider.of<LoginState>(context, listen: false)
                    .loginAnonymous();
              },
              backgroundColor: Colors.grey[600],
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
              text: 'Inicio de sesión con Google',
              onPressed: () {
                Provider.of<LoginState>(context, listen: false).loginGoogle();
              },
            ),
            Divider(),
            RichText(
              text: TextSpan(
                  text: '¿No tienes una cuenta?',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Regístrate',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to desired screen
                          })
                  ]),
            ),
          ],
        ),
      ),
    ));
  }
}
