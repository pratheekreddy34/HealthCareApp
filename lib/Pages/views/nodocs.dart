import 'package:flutter/material.dart';

class nodoctors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Sorry. No doctors Available right now. \n \t \t \t \t \t \t \t Try again later? ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                  color: Colors.black87.withOpacity(0.8),
                  fontFamily: 'Pacifico'),
            ),
          ),
        ),
      ),
    );
  }
}
