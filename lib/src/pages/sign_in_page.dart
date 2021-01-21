import 'package:Fontana/src/states/log_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = '';
  String password = '';
  TextEditingController _editingControllerEmail;
  TextEditingController _editingControllerPasswd;

  void initState() {
    super.initState();
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
                              text: 'Introduzca sus datos',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent[400],
                                  fontSize: 27,
                                  fontFamily: 'PermanentMarker'))),
                      SizedBox(
                        height: 30,
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
                        text: 'Iniciar Sesion',
                        icon: Icons.email,
                        onPressed: () {
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
                        width: 140.0,
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
