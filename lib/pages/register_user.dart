import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entries/user.dart';
import '../entries/results.dart';
import '../widgets/password_field.dart';
import '../tools/crypto_tool.dart';
import '../tools/request_parser.dart';
import '../widgets/dialog_shower.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final User user = new User();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      new _UsNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Register'),
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
                            labelText: "Username *",
                            hintText: 'Accout name for login.'),
                        onSaved: (String value) {
                          user.userName = value;
                        },
//                    onFieldSubmitted: _validateName,
                        validator: _validateName,
                        maxLength: 32,
                      ),
                      const SizedBox(height: 8.0),
                      new TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: true,
                            icon: Icon(Icons.person, color: Colors.transparent),
                            labelText: "Nickname *",
                            hintText: 'What do people call you?'),
                        onSaved: (String value) {
                          user.nickName = value;
                        },
//                    onFieldSubmitted: _validateNickName,
                        validator: _validateNickName,
                        maxLength: 32,
                      ),
                      const SizedBox(height: 8.0),
                      new PasswordField(
                        fieldKey: _passwordFieldKey,
                        helperText: 'No more than 16 characters.',
                        labelText: 'Password *',
                        onFieldSubmitted: (String value) {
//                      _validatePassword(value);
                          setState(() {
                            user.password = value;
                          });
                        },
                        onSaved: (String value) {
                          user.password = generateMd5(value);
                        },
                      ),
                      const SizedBox(height: 8.0),
                      new TextFormField(
                        enabled:
                            user.password != null && user.password.isNotEmpty,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          icon: Icon(
                            Icons.lock,
                            color: Colors.transparent,
                          ),
                          labelText: 'Re-type password',
                        ),
                        maxLength: 16,
                        obscureText: true,
//                    onFieldSubmitted: _validatePasswordRe,
                        validator: _validatePasswordRe,
                      ),
                      const SizedBox(height: 8.0),
                      new TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          icon: Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                          ),
                          helperText: 'Find back password, can not be changed.',
                          hintText: 'Your email address',
                          labelText: 'Email *',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String value) {
                          user.email = value;
                        },
//                    onFieldSubmitted: _validateEmail,
                        validator: _validateEmail,
                      ),
//                  const SizedBox(height: 8.0),
//                  new TextFormField(
//                    decoration: const InputDecoration(
//                      border: UnderlineInputBorder(),
//                      filled: true,
//                      icon: Icon(
//                        Icons.phone,
//                        color: Colors.blueAccent,
//                      ),
//                      hintText: 'Where can we reach you?',
//                      labelText: 'Phone Number',
//                    ),
//                    keyboardType: TextInputType.phone,
//                    onSaved: (String value) {
//                      user.phone = value;
//                    },
//                    validator: _validatePhoneNumber,
//                    // TextInputFormatters are applied in sequence.
//                    inputFormatters: <TextInputFormatter>[
//                      WhitelistingTextInputFormatter.digitsOnly,
//                      // Fit the validating format.
//                      _phoneNumberFormatter,
//                    ],
//                  ),
//                  const SizedBox(height: 8.0),
//                  new TextFormField(
//                    textCapitalization: TextCapitalization.words,
//                    maxLines: 3,
//                    decoration: const InputDecoration(
//                        border: OutlineInputBorder(),
//                        icon:
//                            Icon(Icons.location_city, color: Colors.blueAccent),
//                        labelText: "Address"),
//                    onSaved: (String value) {
//                      user.address = value;
//                    },
//                    validator: _validateName,
//                    maxLength: 128,
//                  ),
                      const SizedBox(height: 8.0),
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: new RaisedButton(
                            color: Colors.lightGreen,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: _handleSubmitted),
                      ),
                      const SizedBox(height: 16.0),
                      new Container(
                          alignment: Alignment.centerRight,
                          child: new FlatButton(
                              onPressed: _backToLogin,
                              child: new Text(
                                'To Login',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 12.0),
                              ))),
                      const SizedBox(height: 24.0),
                      new Text('* indicates required field',
                          style: Theme.of(context).textTheme.caption),
                      const SizedBox(height: 8.0)
                    ],
                  ),
                ))));
  }

  void _backToLogin() {
    Navigator.of(context).pop();
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'User name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validateNickName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Nick name is required.';
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

  String _validatePasswordRe(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return 'Please enter a password.';
    }
    if (passwordField.value.length < 6) {
      return 'Password is too short, the minimal length is 6.';
    }
    if (passwordField.value != value) return 'The passwords don\'t match';
    return null;
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp =
        new RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
    if (!nameExp.hasMatch(value)) return 'Please enter correct email.';
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _showRegisterDialog();
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
              future: RequestParser.registerUser('/user/register',
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
                        okAction = DialogAction.login;
                        okTxt = 'TO LOGIN';
                        return new Text(
                            "Resite success, Welcome ${(snapshot.data as User).nickName} join us.");
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

  void _dialogActionClicked(value) {
    if (value == DialogAction.login) {
      _backToLogin();
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String _validatePhoneNumber(String value) {
    print("_validatePhoneNumber: $value");
    _formWasEdited = true;
    final RegExp phoneExp = new RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
