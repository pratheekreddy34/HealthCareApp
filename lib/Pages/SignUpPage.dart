import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email;
  String _password;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      style: style,
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

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password)
              .then((signedInUser) {
            UserManagement().storeNewUser(signedInUser, context);
            Navigator.of(context).pushReplacementNamed('/landingpage');
          }).catchError((e) {
            print(e);
          });
        },
        child: Text("Create Account ",
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
                        'Enter Credentials ',
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
                      signupButton,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
