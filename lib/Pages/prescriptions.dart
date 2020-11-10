//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class prescription {
  String _name;
  String _dosage;
  bool _completed;
  prescription(this._name, this._dosage);
  getName() => this._name;
  getDosage() => this._dosage;
  setName(name) => this._name = name;
  setDosage(dosage) => this._dosage = dosage;
  isCompleted() => this._completed;
  setCompleted(completed) => this._completed = completed;
}

class prescriptionspage extends StatefulWidget {
  @override
  _prescriptionspageState createState() => _prescriptionspageState();
}

class _prescriptionspageState extends State<prescriptionspage> {
  final List<prescription> prescs = [];
  final prescollection = FirebaseFirestore.instance.collection('prescriptions');
  void onPrescreated(String Name, String Dosage) {
    setState(() {
      prescs.add(prescription(Name, Dosage));
    });
  }

  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/create': (context) => CreatePres(
              onCreate: onPrescreated,
            )
      },
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'My Prescriptions',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
          ),
          elevation: 0.0,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.black87),
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: prescollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading..');
              default:
                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          document['Name'],
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.justify,
                        ),
                        subtitle: Text(
                          document['Dosage'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                          textAlign: TextAlign.justify,
                        ),
                        enabled: true,
                        onLongPress: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                      shadowColor: Colors.black,
                      shape: selected
                          ? new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0))
                          : new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                      elevation: 10.0,
                    );
                  }).toList(),
                );
            }
          },
        ),

        /*ListView.builder(
          itemCount: prescs.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                  title: Text(prescs[index].getName()),
                  subtitle: Text(prescs[index].getDosage()),
                  enabled: true,
                ),
                shadowColor: Colors.black,
                shape: selected
                    ? new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0))
                    : new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ));
          },
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      new CreatePres(onCreate: onPrescreated))),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class CreatePres extends StatefulWidget {
  @override
  _CreatePresState createState() => _CreatePresState();
  final onCreate;
  CreatePres({@required this.onCreate});
}

class _CreatePresState extends State<CreatePres> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController doscontroller = TextEditingController();
  final prescollection = FirebaseFirestore.instance.collection('prescriptions');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a prescription'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: namecontroller,
                  decoration:
                      InputDecoration(labelText: 'Enter Your Prescription'),
                ),
                TextField(
                  autofocus: true,
                  controller: doscontroller,
                  decoration: InputDecoration(labelText: 'Enter the dosage'),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          await prescollection
              .add({'Name': namecontroller.text, 'Dosage': doscontroller.text});
          Navigator.pop(context);
        },
      ),
    );
  }
}
