import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tags/services/auth.dart';


class PersonalDetailsForm extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback nextPage;

  PersonalDetailsForm(this.auth, this.nextPage);
  
  @override
  State<StatefulWidget> createState() => _PersonalDetailsForm();
}

class _PersonalDetailsForm extends State<PersonalDetailsForm> {

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _textFieldPadding = EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: _textFieldPadding,
              child: TextFormField(
                decoration: InputDecoration(labelText: "First name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your first name";
                  }
                },
                onSaved: (value) {
                  _updateProfile({"firstName": value});
                },
              ),
            ),
            Padding(
              padding: _textFieldPadding, 
              child: TextFormField(
                decoration: InputDecoration(labelText: "Last name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your last name";
                  }
                },
                onSaved: (value) {
                  _updateProfile({"firstName": value});
                },
              ),
            ),
            Padding(
              padding: _textFieldPadding,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                  
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your title";
                  }
                },
                onSaved: (value) {
                  _updateProfile({"firstName": value});
                },
              ),
            ),
            Align(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: RaisedButton(
                  color: Colors.yellow[600],
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      widget.nextPage();
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                    ),  
                  )
                )
              ),
              alignment: Alignment.bottomCenter,
            ),
          ],
        )
      )
    );
  }
  _updateProfile(newValues) async {
    var user = await widget.auth.getCurrentUser();
    var token = await user.getIdToken();
    print("=== UPDATING === " + token.substring(0, 10));
    Firestore.instance
    .collection("test-for-dev")
    .document(token)
    .updateData(newValues)
    .catchError((e) {
      print(e);
    });
  }
}