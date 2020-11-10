import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/home.dart';

import 'chatwindow.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _email;
  String _password;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      style: style,
      obscureText: false,
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(64.0),
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(64.0),
            borderSide: BorderSide(color: Colors.black, width: 3.0)),
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password)
              .then((User) {
            Navigator.of(context).pushReplacementNamed('/homepage');
          }).catchError((e) {
            print(e);
          });
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final SignupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pushNamed('/signup');
        },
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('Images/logo.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Welcome ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                          fontSize: 40.0,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButton,
                      SizedBox(
                        height: 15.0,
                      ),
                      SignupButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
