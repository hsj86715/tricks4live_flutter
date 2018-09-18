import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/constants.dart';
import '../tools/user_tool.dart';
import '../tools/request_parser.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
            _buildUserHeader(context),
            const Divider(height: 3.0, color: Colors.black87),
            new ListTile(
              leading: new SvgPicture.asset('assets/icons/ic_published.svg',
                  width: 36.0, height: 36.0),
              title: new Text('My Published'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: new SvgPicture.asset('assets/icons/ic_improve.svg',
                  width: 36.0, height: 36.0),
              title: new Text('My Improve'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: new SvgPicture.asset('assets/icons/ic_verified.svg',
                  width: 36.0, height: 36.0),
              title: new Text('My Verified'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: new SvgPicture.asset('assets/icons/ic_focus_empty.svg',
                  width: 36.0, height: 36.0),
              title: new Text('My Focused'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: new SvgPicture.asset(
                  'assets/icons/ic_favorite_empty.svg',
                  width: 36.0,
                  height: 36.0),
              title: new Text('My Collections'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 1.0, color: Colors.black26),
            new ListTile(
              leading: new SvgPicture.asset('assets/icons/ic_comments.svg',
                  width: 36.0, height: 36.0),
              title: new Text('My Commented'),
              trailing: new SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                  width: 24.0, height: 24.0),
            ),
            const Divider(height: 3.0, color: Colors.black87),
            new Container(
                padding: const EdgeInsets.all(32.0),
                child: new RaisedButton(
                  color: Colors.redAccent,
                  onPressed: _loginOut,
                  child: const Text(
                    "Login Out",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ))
          ]),
        ));
  }

  Widget _buildUserHeader(BuildContext context) {
    return new Container(
      color: const Color(0xff283593),
      height: 200.0,
      child: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SvgPicture.asset(
            'assets/icons/ic_avatar.svg',
            width: 120.0,
            height: 120.0,
          ),
          const SizedBox(height: 8.0),
          new Text(
            UserUtil.loginUser.nickName,
            style: new TextStyle(color: Colors.white, fontSize: 18.0),
          )
        ],
      )),
    );
  }

  void _loginOut() {
    RequestParser.loginOut(UserUtil.loginUser.token);
    _prefs.then((SharedPreferences prefs) {
      prefs.remove(Strings.PREFS_KEY_LOGIN_USER);
    });
    UserUtil.loginUser = null;
    Navigator.of(context).pop();
  }
}
