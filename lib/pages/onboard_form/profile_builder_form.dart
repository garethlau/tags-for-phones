import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tags/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
  Future<Null> getImage() async {
    print("=== IMAGE PICKER ===");
    File picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200.0,
      maxHeight: 300.0,
    );
    setState(() {
      image = picture;
    });
    cropImage();
  }

  Future<Null> cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      toolbarTitle: "Cropper",
      toolbarColor: Colors.yellow[600],
      toolbarWidgetColor: Colors.white,
      maxWidth: 300,
      maxHeight: 300,
      ratioX: 1.0,
      ratioY: 1.0,
    );
    if (croppedFile != null) {
      setState(() {
        image = croppedFile;
      });
    }
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
              child: Container(
                width: 250,
                height: 250,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: image == null
                  ? Container(
                      child: FlutterLogo(
                      ),
                    )
                  : InkWell(
                      child: Image.file(image),
                      onTap: () {
                        getImage();
                      },
                    ), 
                ) 
              )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: RaisedButton(
                color: Colors.yellow[600],
                child: image == null
                ? Text("Upload image", style: TextStyle(color: Colors.white),)
                : Text("Remove image", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if (image == null) {
                    getImage();
                  }
                  else {
                    setState(() {
                      image = null;
                    });
                  }
                }
              ),
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