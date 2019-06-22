import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tags/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

class ProfileBuilderForm extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  ProfileBuilderForm(this.auth, this.nextPage, this.prevPage);
  
  @override
  State<StatefulWidget> createState() => _ProfileBuilderForm();
}

class _ProfileBuilderForm extends State<ProfileBuilderForm> {

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textFieldPadding = EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0);

  File image;
  Future getImage() async {
    print("=== IMAGE PICKER ===");
    File picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 300.0,
      maxHeight: 300.0,
    );
    setState(() {
      image = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: InkWell(
                  child: Container(
                    color: Colors.green,
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 1.5,
                  ),
                onTap: getImage,
                ),
              ) 
            ), 
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