import 'package:flutter/material.dart';
import 'package:fontana/src/log_in_state.dart';
import 'package:provider/provider.dart';

class  LogInPage extends StatelessWidget {
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
              RaisedButton(
                child: Text('Inicia Sesión'),
                onPressed: () {
                Provider.of<LoginState>(context, listen: false).login();
              })
            ],
          ),
        ),
      ),
    );
  }
}
