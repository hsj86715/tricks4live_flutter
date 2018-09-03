import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entries/user.dart';
import '../widgets/password_field.dart';
import '../tools/crypto_tool.dart';

class RegisterUi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterUiState();
  }
}

class _RegisterUiState extends State<RegisterUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final User user = new User();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      new _UsNumberTextInputFormatter();

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
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
                  new TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.person, color: Colors.transparent),
                        labelText: "Nickname *",
                        hintText: 'Show for other users.'),
                    onSaved: (String value) {
                      print("Nickname: $value");
                      user.nickName = value;
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
                        user.password = generateMd5(value);
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  new TextFormField(
                    enabled: user.password != null && user.password.isNotEmpty,
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
                    validator: _validatePassword,
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
                      hintText: 'Your email address',
                      labelText: 'E-mail *',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (String value) {
                      print("E-mail: $value");
                      user.email = value;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  new TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blueAccent,
                      ),
                      hintText: 'Where can we reach you?',
                      labelText: 'Phone Number',
//              prefixText: '+1',
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (String value) {
                      print("Phone Number: $value");
                      user.phone = value;
                    },
                    validator: _validatePhoneNumber,
                    // TextInputFormatters are applied in sequence.
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      // Fit the validating format.
                      _phoneNumberFormatter,
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  new TextFormField(
                    textCapitalization: TextCapitalization.words,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon:
                            Icon(Icons.location_city, color: Colors.blueAccent),
                        labelText: "Address",
                        hintText: 'Show for other users.'),
                    onSaved: (String value) {
                      print("Address: $value");
                      user.address = value;
                    },
                    validator: _validateName,
                    maxLength: 128,
                  ),
                  const SizedBox(height: 8.0),
                  new Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: new RaisedButton(
                        color: Colors.lightGreen,
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        onPressed: _handleSubmitted),
                  ),
//          const SizedBox(height: 16.0),
//          new Container(
//              padding: const EdgeInsets.symmetric(horizontal: 16.0),
//              child: new FlatButton(
//                  onPressed: _backToLogin,
//                  child: new Text(
//                    'To Login',
//                    textAlign: TextAlign.end,
//                    style: TextStyle(color: Colors.blueAccent, fontSize: 12.0),
//                  ))),
                  const SizedBox(height: 24.0),
                  new Text('* indicates required field',
                      style: Theme.of(context).textTheme.caption),
                  const SizedBox(height: 8.0)
                ],
              ),
            )));
  }

  void _backToLogin() {
    Navigator.of(context).pop();
  }

  String _validateName(String value) {
    print("_validateName: $value");
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePassword(String value) {
    print("_validatePassword: $value");
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value) return 'The passwords don\'t match';
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
