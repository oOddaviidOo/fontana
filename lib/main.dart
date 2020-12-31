import 'package:flutter/material.dart';
import 'package:fontana/src/pages/home_page.dart';
import 'package:fontana/src/pages/log_in_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
    bool _loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       title: 'Fontana',
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       routes: {
         '/': (BuildContext context){
           if (_loggedIn) {
             return HomePage();
           } else {
             return LogInPage(
               onLoginSuccess: (){
                 setState(() {
                   _loggedIn = true;
                 });
               },
             );
           }
         }
       },
    );
  }
}
