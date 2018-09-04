import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entries/user.dart';
import '../widgets/password_field.dart';
import 'register_user.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final User user = new User();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: new SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      new TextFormField(
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            icon: Icon(Icons.person, color: Colors.blueAccent),
                            labelText: "Username *"),
                        onSaved: (String value) {
                          user.userName = value;
                        },
                        validator: _validateName,
                        maxLength: 32,
                      ),
                      const SizedBox(height: 8.0),
                      new PasswordField(
                        fieldKey: _passwordFieldKey,
                        helperText: 'No more than 16 characters.',
                        labelText: 'Password *',
                        onFieldSubmitted: (String value) {
                          setState(() {
                            user.password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: new RaisedButton(
                            color: Colors.lightGreen,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: _handleSubmitted),
                      ),
                      const SizedBox(height: 16.0),
                      new Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new FlatButton(
                                  child: new Text(
                                    'Forgot password',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 12.0),
                                  ),
                                  onPressed: _pushFindBack),
                              new FlatButton(
                                color: Colors.transparent,
                                child: new Text(
                                  'Register',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 12.0),
                                ),
                                onPressed: _pushRegister,
                              )
                            ],
                          )),
                      const SizedBox(height: 24.0),
                      new Text('* indicates required field',
                          style: Theme.of(context).textTheme.caption),
                      const SizedBox(height: 8.0)
                    ],
                  ),
                ))));
  }

  void _pushRegister() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new RegisterPage();
    }));
  }

  void _pushFindBack() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Find back password'),
        ),
        body: new FindBackPasswordUi(),
      );
    }));
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('${user.userName}\'s phone number is ${user.phone}');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
