import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:tags/pages/login_signup_page.dart';
import 'package:tags/services/auth.dart';
import 'package:tags/pages/home_page.dart';
import 'package:tags/pages/onboard_page.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool showOnboard = false;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _changeOnboardStatus () async {
    print("SHOW THE ONBOARDING SCREEN");
    setState(() {
      showOnboard = true;
    });

    var user = await widget.auth.getCurrentUser();
    String email = user.email;
    Firestore.instance.collection("test-for-dev").document(email).setData({
      "email": user.email,
      "image": user.photoUrl,
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          changeOnboardStatus: _changeOnboardStatus,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId != null && _userId.length > 0) {
          if (true) { // replace true with showOnboard
            return OnboardPage(
              userId: _userId,
              auth: widget.auth,
            );
          }
          return HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        }
        else {
          return _buildWaitingScreen();
        }
        break;
      default: 
        return _buildWaitingScreen();
    }
  }

}