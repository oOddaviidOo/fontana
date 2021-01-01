import 'package:flutter/material.dart';
import 'package:fontana/src/log_in_state.dart';
import 'package:fontana/src/pages/home_page.dart';
import 'package:fontana/src/pages/log_in_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fontana',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (BuildContext context) {
              var state = Provider.of<LoginState>(context);
              if (state.isLoggedIn()) {
                return HomePage();
              } else {
                return LogInPage();
              }
            }
          }),
    );
  }
}
