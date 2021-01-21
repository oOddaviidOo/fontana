import 'package:Fontana/src/states/log_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String nombre = '';
  String email = '';
  String password = '';
  TextEditingController _editingControllerNom;
  TextEditingController _editingControllerEmail;
  TextEditingController _editingControllerPasswd;

  void initState() {
    super.initState();
    _editingControllerNom = TextEditingController();
    _editingControllerEmail = TextEditingController();
    _editingControllerPasswd = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Rellene el formulario de registro',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent[400],
                                  fontSize: 27,
                                  fontFamily: 'PermanentMarker'))),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _editingControllerNom,
                          decoration: InputDecoration(
                              hintText: 'Nombre y Apellidos',
                              labelText: 'Nombre y Apellidos',
                              helperText: 'Ej: Andrés García',
                              //icon: Icon(Icons.account_circle),
                              //prefixIcon: Icon(Icons.title)
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          onChanged: (String s) {
                            nombre = s;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _editingControllerEmail,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              helperText: 'Ej: andres_garcia@gmail.com',
                              //icon: Icon(Icons.account_circle),
                              //prefixIcon: Icon(Icons.title)
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          onChanged: (String s) {
                            email = s;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _editingControllerPasswd,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Contraseña',
                              labelText: 'Contraseña',

                              //icon: Icon(Icons.account_circle),
                              //prefixIcon: Icon(Icons.title)
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          onChanged: (String s) {
                            password = s;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SignInButtonBuilder(
                        text: 'Registrarse',
                        icon: Icons.email,
                        onPressed: () {
                          Provider.of<LoginState>(context, listen: false)
                              .registerEmail(email, password);
                          Provider.of<LoginState>(context, listen: false)
                              .signInEmail(email, password);
                          if (Provider.of<LoginState>(context, listen: false)
                              .isLoggedIn()) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ));
                          }
                        },
                        backgroundColor: Colors.blueGrey[700],
                        width: 130.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
