import 'package:flutter/material.dart';
import 'package:tags/pages/onboard_form/contact_details_form.dart';
import 'package:tags/services/auth.dart';
import 'package:tags/models/profile.dart';
import 'package:tags/pages/onboard_form/personal_details_form.dart';
import 'package:tags/pages/onboard_form/profile_builder_form.dart';

class OnboardPage extends StatefulWidget {
  final BaseAuth auth;
  final String userId;

  OnboardPage({Key key, this.auth, this.userId}): super(key: key);

  @override
  State<StatefulWidget> createState() => new _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {

  final _profile = Profile();
  final _pageController = PageController(initialPage: 0);

  nextPage() {
    _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
  }

  prevPage() {
    _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to Tags",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            PersonalDetailsForm(widget.auth, nextPage),
            ContactDetailsForm(widget.auth, nextPage, prevPage),
            ProfileBuilderForm(widget.auth, nextPage, prevPage),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
    );
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Saving..."),
        backgroundColor: Colors.red,
      )
    );
  }



}
