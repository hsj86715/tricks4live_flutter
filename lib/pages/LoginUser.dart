import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tricks4live/entries/User.dart';
import 'package:tricks4live/entries/Results.dart';
import 'package:tricks4live/tools/Constants.dart';
import 'package:tricks4live/widgets/PasswordField.dart';
import 'package:tricks4live/widgets/DialogShower.dart';
import 'package:tricks4live/pages/RegisterUser.dart';
import 'package:tricks4live/pages/ForgetPassword.dart';
import 'package:tricks4live/tools/RequestParser.dart';
import 'package:tricks4live/tools/CryptoUtils.dart';
import 'package:tricks4live/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tricks4live/tools/UserUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User user = User();

  bool _autoValidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(S.of(context).pageLogin)),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      TextFormField(
                          textCapitalization: TextCapitalization.words,
                          autofocus: true,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              icon:
                                  Icon(Icons.person, color: Colors.blueAccent),
                              labelText:
                                  S.of(context).fieldUserName),
                          onSaved: (String value) {
                            user.userName = value;
                          },
                          validator: _validateName,
                          maxLength: 32),
                      const SizedBox(height: 8.0),
                      PasswordField(
                          fieldKey: _passwordFieldKey,
                          helperText: S.of(context)
                              .fieldPasswordHelper,
                          labelText:
                              S.of(context).fieldPassword,
                          onFieldSubmitted: (String value) {
                            setState(() {
                              user.password = value;
                            });
                          },
                          onSaved: (String value) {
                            user.password = generateMd5(value);
                          },
                          validator: _validatePassword),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: RaisedButton(
                            color: Colors.lightGreen,
                            child: Text(S.of(context).btnLogin,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            onPressed: _handleSubmitted),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                  child: Text(
                                      S.of(context)
                                          .btnForgetPwd,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12.0)),
                                  onPressed: _pushFindBack),
                              FlatButton(
                                  color: Colors.transparent,
                                  child: Text(
                                      S.of(context)
                                          .btnRegister,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12.0)),
                                  onPressed: _pushRegister)
                            ],
                          )),
                      const SizedBox(height: 24.0),
                      Text(S.of(context).formRequiredHint,
                          style: Theme.of(context).textTheme.caption),
                      const SizedBox(height: 8.0)
                    ],
                  ),
                ))));
  }

  void _pushRegister() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegisterPage();
    }));
  }

  void _pushFindBack() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text('Find back password')),
          body: FindBackPasswordUi());
    }));
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return S.of(context).fieldUserNameEmpty;
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return S.of(context).fieldUserNameMatch;
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return S.of(context).fieldPasswordEmpty;
    if (value.length < 6) {
      return S.of(context).fieldPasswordTooShort;
    }
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar(S.of(context).formErrorHint);
    } else {
      form.save();
      _showLoginDialog();
//      showInSnackBar('${user.userName}\'s phone number is ${user.phone}');
    }
  }

  void _showLoginDialog() {
    bool dismissAble = false;
    DialogAction okAction = DialogAction.ok;
    String okTxt = S.of(context).btnOK;
    showCustomDialog(
        context: context,
        child: AlertDialog(
          content: FutureBuilder(
              future: RequestParser.loginUser(user),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    dismissAble = false;
                    return Container(
                        width: 48.0,
                        height: 48.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator());
                  default:
                    dismissAble = true;
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      okAction = DialogAction.retry;
                      okTxt = S.of(context).btnRetry;
                      return Text('Error: ${snapshot.error}');
                    } else {
                      print('Result: ${snapshot.data}');
                      if (snapshot.data is User) {
                        _saveUserToPrefs(snapshot.data);
                        okAction = DialogAction.ok;
                        okTxt = S.of(context).btnOK;
                        return Text(S.of(context)
                            .loginWelcome((snapshot.data as User).nickName));
                      } else {
                        okAction = DialogAction.edit;
                        okTxt = S.of(context).btnReedit;
                        return Text((snapshot.data as Result).msg);
                      }
                    }
                }
              }),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  if (dismissAble) {
                    Navigator.pop(context, DialogAction.cancel);
                  }
                },
                child: Text(S.of(context).btnCancel)),
            FlatButton(
                onPressed: () {
                  if (dismissAble) {
                    Navigator.pop(context, okAction);
                  }
                },
                child: Text(okTxt))
          ],
        ),
        action: _dialogActionClicked);
  }

  void _saveUserToPrefs(User user) {
    _prefs.then((SharedPreferences prefs) {
      UserUtil.getInstance().loginUser = user;
      String loginUser = json.encode(user);
      prefs.setString(Strings.PREFS_KEY_LOGIN_USER, loginUser);
    });
  }

  void _dialogActionClicked(value) {
    if (value == DialogAction.ok) {
      Navigator.of(context).pop();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
