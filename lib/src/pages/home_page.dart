import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../log_in_state.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

getImage(User user) {
  if (user.isAnonymous) {
    return AssetImage('assets/images/anonymous.png');
  } else {
    return NetworkImage(user.photoURL);
  }
}

String getNombre(User user) {
  if (user.isAnonymous) {
    return 'Usuario anónimo';
  } else {
    return user.displayName;
  }
}

class _HomePageState extends State<HomePage> {
  User user;
  String saludo;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<LoginState>(context, listen: false).user.user;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: getImage(user),
                      radius: 50,
                    ),
                    RichText(
                        text: TextSpan(
                            text: (getNombre(user)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ))),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar Sesión'),
              onTap: () {
                if (Provider.of<LoginState>(context, listen: false)
                    .user
                    .user
                    .isAnonymous) {
                  Provider.of<LoginState>(context, listen: false)
                      .logoutAnonymous();
                } else {
                  Provider.of<LoginState>(context, listen: false)
                      .logoutGoogle();
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Fontana'),
      ),
      body: Container(),
    );
  }
}
