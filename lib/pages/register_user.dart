import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../entries/user.dart';
import '../entries/results.dart';
import '../widgets/password_field.dart';
import '../tools/crypto_tool.dart';
import '../tools/request_parser.dart';
import '../widgets/dialog_shower.dart';
import '../tools/common_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User user = User();

  bool _autovalidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      _UsNumberTextInputFormatter();
  File _avatarImage;

  void getImage() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((File image) {
      print(image.path);
      ImageCropper.cropImage(
              sourcePath: image.path,
              ratioX: 1.0,
              ratioY: 1.0,
              maxHeight: 120,
              maxWidth: 120)
          .then((File cropped) {
        setState(() {
          _avatarImage = cropped;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(CommonUtils.getLocale(context).pageRegister),
        ),
        body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 8.0),
                          Center(
                              child: GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: _avatarImage == null
                                          ? AssetImage('assets/ic_avatar.png')
                                          : FileImage(_avatarImage)))),
                          const SizedBox(height: 8.0),
                          TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: true,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.person,
                                      color: Colors.blueAccent),
                                  labelText: CommonUtils.getLocale(context)
                                      .fieldUserName,
                                  hintText: CommonUtils.getLocale(context)
                                      .fieldUserNameHint),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                print('onEditingComplete');
                              },
                              onFieldSubmitted: (value) {
                                print('onFieldSubmitted: $value');
                              },
                              onSaved: (String value) {
                                print('onSaved: $value');
                                user.userName = value;
                              },
                              validator: (value) {
                                print('validator: $value');
                                _validateName(value);
                              },
                              maxLength: 32),
                          const SizedBox(height: 4.0),
                          TextFormField(
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.person,
                                      color: Colors.transparent),
                                  labelText: CommonUtils.getLocale(context)
                                      .fieldNickName,
                                  hintText: CommonUtils.getLocale(context)
                                      .fieldNickNameHint),
                              onSaved: (String value) {
                                user.nickName = value;
                              },
                              validator: _validateNickName,
                              maxLength: 32),
                          const SizedBox(height: 4.0),
                          PasswordField(
                              fieldKey: _passwordFieldKey,
                              helperText: CommonUtils.getLocale(context)
                                  .fieldPasswordHelper,
                              labelText:
                                  CommonUtils.getLocale(context).fieldPassword,
                              onFieldSubmitted: (String value) {
//                      _validatePassword(value);
                                setState(() {
                                  user.password = value;
                                });
                              },
                              onSaved: (String value) {
                                user.password = generateMd5(value);
                              }),
                          const SizedBox(height: 4.0),
                          TextFormField(
                              enabled: user.password != null &&
                                  user.password.isNotEmpty,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                icon:
                                    Icon(Icons.lock, color: Colors.transparent),
                                labelText: CommonUtils.getLocale(context)
                                    .fieldPasswordRepeat,
                              ),
                              maxLength: 16,
                              obscureText: true,
//                    onFieldSubmitted: _validatePasswordRe,
                              validator: _validatePasswordRe),
                          const SizedBox(height: 4.0),
                          TextFormField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.email,
                                      color: Colors.blueAccent),
                                  helperText: CommonUtils.getLocale(context)
                                      .fieldEmailHelper,
                                  hintText: CommonUtils.getLocale(context)
                                      .fieldEmailHint,
                                  labelText: CommonUtils.getLocale(context)
                                      .fieldEmail),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String value) {
                                user.email = value;
                              },
//                    onFieldSubmitted: _validateEmail,
                              validator: _validateEmail),
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
                          const SizedBox(height: 4.0),
                          new Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: RaisedButton(
                                color: Colors.lightGreen,
                                child: Text(
                                    CommonUtils.getLocale(context).btnRegister,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0)),
                                onPressed: _handleSubmitted),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                  onPressed: _backToLogin,
                                  child: Text(
                                      CommonUtils.getLocale(context).btnToLogin,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12.0)))),
                          const SizedBox(height: 24.0),
                          Text(CommonUtils.getLocale(context).formRequiredHint,
                              style: Theme.of(context).textTheme.caption),
                          const SizedBox(height: 8.0)
                        ])))));
  }

  void _backToLogin() {
    Navigator.of(context).pop();
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return CommonUtils.getLocale(context).fieldUserNameEmpty;
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return CommonUtils.getLocale(context).fieldUserNameMatch;
    return null;
  }

  String _validateNickName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return CommonUtils.getLocale(context).fieldNickNameEmpty;
//    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
//    if (!nameExp.hasMatch(value))
//      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return CommonUtils.getLocale(context).fieldPasswordEmpty;
    if (value.length < 6) {
      return CommonUtils.getLocale(context).fieldPasswordTooShort;
    }
    return null;
  }

  String _validatePasswordRe(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return CommonUtils.getLocale(context).fieldPasswordEmpty;
    }
    if (passwordField.value.length < 6) {
      return CommonUtils.getLocale(context).fieldPasswordTooShort;
    }
    if (passwordField.value != value)
      return CommonUtils.getLocale(context).fieldPasswordMatch;
    return null;
  }

  String _validateEmail(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return CommonUtils.getLocale(context).fieldEmailEmpty;
    final RegExp nameExp =
        RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
    if (!nameExp.hasMatch(value))
      return CommonUtils.getLocale(context).fieldEmailMatch;
    return null;
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      _showInSnackBar(CommonUtils.getLocale(context).formErrorHint);
    } else {
      form.save();
      _showRegisterDialog();
    }
  }

  void _showRegisterDialog() {
    bool dismissAble = false;
    DialogAction okAction = DialogAction.ok;
    String okTxt = CommonUtils.getLocale(context).btnOK;
    showCustomDialog(
        context: context,
        child: AlertDialog(
            content: FutureBuilder(
                future: RequestParser.registerUser(user),
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
                        //todo
                        print('Error: ${snapshot.error}');
                        okAction = DialogAction.retry;
                        okTxt = CommonUtils.getLocale(context).btnRetry;
                        return Text('Error: ${snapshot.error}');
                      } else {
                        print('Result: ${snapshot.data}');
                        if (snapshot.data is User) {
                          okAction = DialogAction.login;
                          okTxt = CommonUtils.getLocale(context).btnToLogin;
                          return Text(CommonUtils.getLocale(context)
                              .registerWelcome(
                                  (snapshot.data as User).nickName));
                        } else {
                          okAction = DialogAction.edit;
                          okTxt = CommonUtils.getLocale(context).btnReedit;
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
                  child: Text(CommonUtils.getLocale(context).btnCancel)),
              FlatButton(
                  onPressed: () {
                    if (dismissAble) {
                      Navigator.pop(context, okAction);
                    }
                  },
                  child: Text(okTxt))
            ]),
        action: _dialogActionClicked);
  }

  void _dialogActionClicked(value) {
    if (value == DialogAction.login) {
      _backToLogin();
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: new Text(value)));
  }

  String _validatePhoneNumber(String value) {
    print("_validatePhoneNumber: $value");
    _formWasEdited = true;
    final RegExp phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
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
    final StringBuffer newText = StringBuffer();
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
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
