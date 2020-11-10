import 'package:flutter/material.dart';
import 'Pages/login_page.dart';
import 'Pages/views/home.dart';
import 'Pages/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => new MyApp(),
        '/loginpage': (BuildContext context) => new MyHomePage(),
        '/signup': (BuildContext context) => new SignUpPage(),
        '/homepage': (BuildContext context) => new HomePage()
      },
    );
  }
}
