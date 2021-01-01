import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../log_in_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar Sesión'),
              onTap: () {
                if ( Provider.of<LoginState>(context, listen: false).user.user.isAnonymous
                ) {
                  Provider.of<LoginState>(context, listen: false).logoutAnonymous();
                } else {
                  Provider.of<LoginState>(context, listen: false).logoutGoogle();
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
      body: Center(child: Text('Hola Mundo')),
    );
  }
}
