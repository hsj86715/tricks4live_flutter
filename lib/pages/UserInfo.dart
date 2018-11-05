import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tricks4live_flutter/tools/Constants.dart';
import 'package:tricks4live_flutter/tools/UserUtils.dart';
import 'package:tricks4live_flutter/tools/RequestParser.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tricks4live_flutter/tools/CommonUtils.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(CommonUtils.getLocale(context).pageUserInfo)),
        body: SafeArea(
            top: false,
            bottom: false,
            child: ListView(children: <Widget>[
              _buildUserHeader(context),
              const Divider(height: 3.0, color: Colors.black87),
              ListTile(
                  leading: SvgPicture.asset('assets/icons/ic_published.svg',
                      width: 36.0, height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userPublished),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 1.0, color: Colors.black26),
              ListTile(
                  leading: SvgPicture.asset('assets/icons/ic_improve.svg',
                      width: 36.0, height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userImproved),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 1.0, color: Colors.black26),
              ListTile(
                  leading: SvgPicture.asset('assets/icons/ic_verified.svg',
                      width: 36.0, height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userVerified),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 1.0, color: Colors.black26),
              ListTile(
                  leading: SvgPicture.asset('assets/icons/ic_focus_empty.svg',
                      width: 36.0, height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userFocused),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 1.0, color: Colors.black26),
              ListTile(
                  leading: SvgPicture.asset(
                      'assets/icons/ic_favorite_empty.svg',
                      width: 36.0,
                      height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userCollected),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 1.0, color: Colors.black26),
              ListTile(
                  leading: SvgPicture.asset('assets/icons/ic_comments.svg',
                      width: 36.0, height: 36.0),
                  title: Text(CommonUtils.getLocale(context).userCommented),
                  trailing: SvgPicture.asset('assets/icons/ic_arrow_right.svg',
                      width: 24.0, height: 24.0)),
              const Divider(height: 3.0, color: Colors.black87),
              Container(
                  padding: const EdgeInsets.all(32.0),
                  child: RaisedButton(
                      color: Colors.redAccent,
                      onPressed: _loginOut,
                      child: Text(CommonUtils.getLocale(context).btnLoginOut,
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))))
            ])));
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
        color: const Color(0xff283593),
        height: 200.0,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SvgPicture.asset('assets/icons/ic_avatar.svg',
                  width: 120.0, height: 120.0),
              const SizedBox(height: 8.0),
              Text(UserUtil.getInstance().loginUser.nickName,
                  style: TextStyle(color: Colors.white, fontSize: 18.0))
            ])));
  }

  void _loginOut() {
    RequestParser.loginOut(UserUtil.getInstance().loginUser.token);
    _prefs.then((SharedPreferences prefs) {
      prefs.remove(Strings.PREFS_KEY_LOGIN_USER);
    });
    UserUtil.getInstance().loginUser = null;
    Navigator.of(context).pop();
  }
}
