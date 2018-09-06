import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../tools/constants.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> _user;
  List<String> _userLogin;

  @override
  void initState() {
    super.initState();
    _user = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList(Strings.PREFS_KEY_LOGIN_USER);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('User Info'),
        ),
        body: new SafeArea(
          top: false,
          bottom: false,
          child: new ListView(children: <Widget>[
            new ListTile(
              leading: Icon(MdiIcons.publish, color: Colors.blueAccent),
              title: new Text('My Published'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: Icon(Icons.update, color: Colors.blueAccent),
              title: new Text('My Improve'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: Icon(MdiIcons.verified, color: Colors.blueAccent),
              title: new Text('My Verified'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: Icon(MdiIcons.plusBoxOutline, color: Colors.blueAccent),
              title: new Text('My Focused'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: Icon(Icons.favorite_border, color: Colors.blueAccent),
              title: new Text('My Collections'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: Icon(MdiIcons.commentEyeOutline, color: Colors.blueAccent),
              title: new Text('My Commented'),
              trailing: Icon(MdiIcons.arrowRight, color: Colors.blueGrey),
            ),
            const Divider(height: 3.0, color: Colors.black87)
          ]),
        ));
  }

  Widget _buildUserHeader(BuildContext context) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new FadeInImage.assetNetwork(
              placeholder: '', image: '', width: 150.0, height: 150.0),
          const SizedBox(width: 8.0),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(_userLogin == null ? '' : _userLogin[1]),
              new Text(_userLogin == null ? '' : _userLogin[2])
            ],
          )
        ]);
  }
}
