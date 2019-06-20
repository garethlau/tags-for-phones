import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PersonalDetailsForm extends StatefulWidget {
  final String userId;
  final VoidCallback nextPage;

  PersonalDetailsForm(this.userId, this.nextPage);
  
  @override
  State<StatefulWidget> createState() => _PersonalDetailsForm();
}

class _PersonalDetailsForm extends State<PersonalDetailsForm> {

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "First name"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter your first name";
              }
            },
            onSaved: (value) {
              // _updateProfile({"firstName": value});
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Last name"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter your last name";
              }
            },
            onSaved: (value) {
              //_updateProfile({"firstName": value});
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Title"),
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter your title";
              }
            },
            onSaved: (value) {
              // _updateProfile({"firstName": value});
            },
          ),
          Align(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: RaisedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      widget.nextPage();
                    }
                  },
                  child: Text("Continue")
                )
              ),
              alignment: Alignment.bottomCenter,
            ),
          
        ],
      )
    );
  }
  _updateProfile(newValues) {
    Firestore.instance
    .collection("test-for-dev")
    .document(widget.userId)
    .updateData(newValues)
    .catchError((e) {
      print(e);}
    );
  }
}