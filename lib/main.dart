import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'services/auth.dart';
import 'pages/login_signup_page.dart';
import 'pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tags',
      home: RootPage(auth: new Auth()),
    );
  }
}