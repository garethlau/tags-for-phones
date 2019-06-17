import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tags/services/auth.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  HomePage({Key key, this.auth,this.userId, this.onSignedOut}): super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white
              )
            ),
            onPressed: _signOut,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("ONE"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("TWO"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("THREE"),
            ),
          ),
        ],
      )
    );
  }
}