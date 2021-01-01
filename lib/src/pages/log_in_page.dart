import 'package:flutter/material.dart';
import 'package:fontana/src/log_in_state.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Bienvenido '),
              Row(
                children: [
                  Column(
                    children: [
                      RaisedButton(
                          child: Text('Inicia sesion anonima'),
                          onPressed: () {
                            Provider.of<LoginState>(context, listen: false)
                                .loginAnonymous();
                          }),
                      RaisedButton(
                          child: Text('Inicia sesion con Google'),
                          onPressed: () {
                            Provider.of<LoginState>(context, listen: false)
                                .loginGoogle();
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      RaisedButton(
                          child: Text('Registrate'),
                          onPressed: () {
                            Provider.of<LoginState>(context, listen: false)
                                .loginGoogle();
                          }),
                      RaisedButton(
                          child: Text('Inicia Sesión'),
                          onPressed: () {
                            Provider.of<LoginState>(context, listen: false)
                                .loginGoogle();
                          }),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
