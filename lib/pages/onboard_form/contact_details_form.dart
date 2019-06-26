import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tags/services/auth.dart';


class ContactDetailsForm extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  ContactDetailsForm(this.auth, this.nextPage, this.prevPage);
  
  @override
  State<StatefulWidget> createState() => _ContactDetailsForm();
}

class _ContactDetailsForm extends State<ContactDetailsForm> {

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textFieldPadding = EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: _textFieldPadding,
              child: TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your first name";
                  }
                },
                onSaved: (value) {
                  _updateProfile({"emal": value});
                },
              ),
            ),
            Padding(
              padding: _textFieldPadding,
              child: TextFormField(
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your last name";
                  }
                },
                onSaved: (value) {
                  _updateProfile({"phone": value});
                },
              ),
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: RaisedButton(
                      color: Colors.yellow[600],
                      onPressed: () {
                        final form = _formKey.currentState;
                        form.save();
                        widget.prevPage();
                      },
                      child: Text(
                        "Previous",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                ],
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
    Firestore.instance
    .collection("test-for-dev")
    .document(user.email.toString())
    .updateData(newValues)
    .catchError((e) {
      print(e);
    });
  }
}