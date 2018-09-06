import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entries/user.dart';
import '../entries/results.dart';
import '../tools/constants.dart';
import '../widgets/password_field.dart';
import '../widgets/dialog_shower.dart';
import 'register_user.dart';
import 'forget_password.dart';
import '../tools/request_parser.dart';
import '../tools/crypto_tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final User user = new User();
  List<String> _userLogin;

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
  }

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
                        onSaved: (String value) {
                          user.password = generateMd5(value);
                        },
                        validator: _validatePassword,
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

  String _validatePassword(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Please enter a password.';
    if (value.length < 6) {
      return 'Password is too short, the minimal length is 6.';
    }
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _showRegisterDialog();
//      showInSnackBar('${user.userName}\'s phone number is ${user.phone}');
    }
  }

  void _showRegisterDialog() {
    bool dismissAble = false;
    DialogAction okAction = DialogAction.ok;
    String okTxt = 'OK';
    showCustomDialog(
        context: context,
        child: new AlertDialog(
          content: new FutureBuilder(
              future: RequestParser.registerUser('/user/login',
                  params: json.encode(user)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    dismissAble = false;
                    return new Container(
                        width: 48.0,
                        height: 48.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator());
                  default:
                    dismissAble = true;
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      okAction = DialogAction.retry;
                      okTxt = 'Retry';
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      print('Result: ${snapshot.data}');
                      if (snapshot.data is User) {
                        _saveUserToPrefs(snapshot.data);
                        okAction = DialogAction.ok;
                        okTxt = 'OK';
                        return new Text(
                            "${(snapshot.data as User).nickName}, Welcome back.");
                      } else {
                        okAction = DialogAction.edit;
                        okTxt = 'Re-edit';
                        return new Text((snapshot.data as Result).msg);
                      }
                    }
                }
              }),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  if (dismissAble) {
                    Navigator.pop(context, DialogAction.cancel);
                  }
                },
                child: const Text('CANCEL')),
            new FlatButton(
                onPressed: () {
                  if (dismissAble) {
                    Navigator.pop(context, okAction);
                  }
                },
                child: new Text(okTxt))
          ],
        ),
        action: _dialogActionClicked);
  }

  void _saveUserToPrefs(User user) {
    _prefs.then((SharedPreferences prefs) {
      _userLogin = new List();
      _userLogin.add('${user.id}');
      _userLogin.add(user.nickName);
      _userLogin.add(user.email);
      _userLogin.add(user.token);
      prefs.setStringList(Strings.PREFS_KEY_LOGIN_USER, _userLogin);
    });
  }

  void _dialogActionClicked(value) {
    if (value == DialogAction.ok) {
      Navigator.of(context).pop(_userLogin);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
