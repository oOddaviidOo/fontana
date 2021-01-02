import 'package:Fontana/src/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Fontana/src/states/log_in_state.dart';
import 'package:Fontana/src/pages/home_page.dart';
import 'package:Fontana/src/pages/log_in_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            },
            'profile':(BuildContext context){
              return ProfilePage();
            }
          }),
    );
  }
}

