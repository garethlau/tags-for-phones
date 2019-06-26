import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tags/services/auth.dart';

class LoginSignUpPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback changeOnboardStatus;
  LoginSignUpPage({this.auth, this.onSignedIn, this.changeOnboardStatus});

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage>{
  
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;
  FormMode _formMode = FormMode.LOGIN;
  bool _isLoading;
  bool _isIos = false;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
            _showBody(),
            _showCircularProgress(),
        ],
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showLogo(),
            _showEmailInput(),
            _showPasswordInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage(),
          ],
        )
      ) 
    );
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print("Signed in: $userId");
        }
        else {
          userId = await widget.auth.signUp(_email, _password);
          print("Signed up user: $userId");
        }
        if (userId != null && userId.length > 0) {
          if (_formMode == FormMode.SIGNUP) {
            widget.changeOnboardStatus();
          }
          widget.onSignedIn();
        }
        setState(() {
          _isLoading = false;
        });
      }
      catch (error) {
        print("Error: $error");
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = error.detals;
          }
          else {
            _errorMessage = error.message;
          }
        });
      }
    }
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: FlutterLogo(size: 100.0),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: "Email",
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )
        ),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return "Email can't be empty";
          }
        },
        onSaved: (value) => _email = value,
      )
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          )
        ),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return "Password can't be empty";
          }
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45, 0.0, 0.0),
      child: MaterialButton(
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.yellow[600],
        child: _formMode == FormMode.LOGIN 
          ? Text(
            "Login",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            )
          )
          : Text(
            "Create Account",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
        ? Text(
          "Create new account",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          )
        )
        : Text(
          "Have an account? Sign in",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          )
        ),
        onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  void _changeFormToSignUp() {
    print("change to signup");
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
    _formKey.currentState.reset();
  }
  void _changeFormToLogin() {
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
    _formKey.currentState.reset();
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    }
    else {
      return Container(
        height: 0.0,
      );
    }
  }

}