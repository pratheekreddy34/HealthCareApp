import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWindow extends StatefulWidget {
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String email_user;
  String message;
  getCurrentUser() async {
    User user = await _auth.currentUser;
    email_user = user.email;
    print(email_user);
    return user.email;
  }

  List<String> _messages;

  TextEditingController textEditingController;
  ScrollController scrollController;

  bool enableButton = false;

  @override
  void initState() {
    _messages = List<String>();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  void handleSendMessage() {
    var text = textEditingController.value.text;
    textEditingController.clear();
    setState(() {
      _messages.add(text);
      enableButton = false;
      getCurrentUser();
      _firestore.collection('messages').add({
        'email': email_user,
        'messagetext': message,
      });
    });

    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    var textInput = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  enableButton = text.isNotEmpty;
                  message = text;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: "Type a message",
              ),
              controller: textEditingController,
            ),
          ),
        ),
        enableButton
            ? IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: () {
                  handleSendMessage();
                  print("Printed");
                },
              )
            : IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: null,
              )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(
          "Doctor",
          style: TextStyle(
              color: Colors.white70.withOpacity(0.8),
              fontSize: 25,
              fontFamily: 'SourceSans',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool reverse = false;

                if (email_user != getCurrentUser()) {
                  reverse = true;
                }

                var avatar = Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                  child: CircleAvatar(
                    child: Text("A"),
                  ),
                );

                var triangle = CustomPaint(
                  painter: Triangle(),
                );

                var messagebody = DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_messages[index]),
                    ),
                  ),
                );

                Widget message;

                if (reverse) {
                  message = Stack(
                    children: <Widget>[
                      messagebody,
                      Positioned(right: 0, bottom: 0, child: triangle),
                    ],
                  );
                } else {
                  message = Stack(
                    children: <Widget>[
                      Positioned(left: 0, bottom: 0, child: triangle),
                      messagebody,
                    ],
                  );
                }

                if (reverse) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message,
                      ),
                      avatar,
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      avatar,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Divider(height: 2.0),
          textInput
        ],
      ),
    );
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.amber;

    var path = Path();
    path.lineTo(10, 0);
    path.lineTo(0, -10);
    path.lineTo(-10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
