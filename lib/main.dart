import 'package:ahorradora/pages/login.dart';
import 'package:ahorradora/pages/Menu.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahorradora',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        primaryColor:  Color.fromRGBO(255,160,4,1),
        accentColor: Color.fromRGBO(255,160,4,1),
        cursorColor: Color.fromRGBO(255,160,4,1),
        bottomAppBarColor: Color.fromRGBO(45,61,84,1),
        backgroundColor: Color.fromRGBO(39,53,73, 1),
        buttonColor:Color.fromRGBO(255,160,4,1),
        textTheme: new TextTheme(
          button: new TextStyle(
            fontSize: 16,
          ),
          subhead: new TextStyle(
            fontSize: 20,
          )
        ),
        appBarTheme: new AppBarTheme(
          color: Color.fromRGBO(45,61,84,1),
          textTheme: new TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          )
        )
      ),
      routes: {
        '/':(contex)=> Login(title: 'Login'),
        '/menu': (context) => Menu(title: 'Menu'),
      },
    );
  }
}
