import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  final Function onLoginSuccess;
  LogInPage({Key key, this.onLoginSuccess}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Bienvenido'),
              RaisedButton(
                child: Text('Inicia Sesión'),
                onPressed: () {
                widget.onLoginSuccess();
              })
            ],
          ),
        ),
      ),
    );
  }
}
