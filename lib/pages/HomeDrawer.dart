import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tricks4live/tools/Constants.dart';
import 'package:tricks4live/tools/UserUtils.dart';
import 'package:tricks4live/entries/User.dart';
import 'package:tricks4live/pages/LoginUser.dart';
import 'package:tricks4live/pages/UserInfo.dart';
import 'package:tricks4live/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeDrawerUi extends StatefulWidget {
  HomeDrawerUi();

  @override
  State<StatefulWidget> createState() {
    return new _HomeDrawerUiState();
  }
}

class _HomeDrawerUiState extends State<HomeDrawerUi> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<User> _user;

  _onNavItemClicked(String itemName) {
    print(itemName);
    if (itemName == Strings.NAV_HOME) {
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _user = _prefs.then((SharedPreferences prefs) {
      String loginUser = prefs.getString(Strings.PREFS_KEY_LOGIN_USER);
      if (loginUser != null && loginUser.isNotEmpty) {
        UserUtil.getInstance().loginUser =
            UserUtil.parseUser(json.decode(loginUser));
      }
      return UserUtil.getInstance().loginUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          FutureBuilder(
              future: _user,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (!snapshot.hasError) {
                      print(snapshot.data);
                    }
                    return UserAccountsDrawerHeader(
                        accountName: Text(
                            UserUtil.getInstance().loginUser == null
                                ? S.of(context).navClickToLogin
                                : UserUtil.getInstance().loginUser.nickName),
                        accountEmail: Text(
                            UserUtil.getInstance().loginUser == null
                                ? ""
                                : UserUtil.getInstance().loginUser.email),
                        currentAccountPicture: GestureDetector(
                            onTap: _checkLogin,
                            child: SvgPicture.asset(
                                'res/drawables/ic_avatar.svg',
                                width: 120.0,
                                height: 120.0)),
                        onDetailsPressed: _checkLogin);
                }
              }),
          ListTile(
              leading: SvgPicture.asset('res/drawables/ic_home.svg',
                  width: 36.0, height: 36.0),
              title: Text(S.of(context).navHome),
              onTap: () {
                _onNavItemClicked(Strings.NAV_HOME);
              }),
          Divider(color: Colors.blueGrey),
          ListTile(
              leading: SvgPicture.asset('res/drawables/ic_share.svg',
                  width: 36.0, height: 36.0),
              title: Text(S.of(context).navShare),
              onTap: () {
                _onNavItemClicked(Strings.NAV_SHARE);
              }),
          ListTile(
              leading: SvgPicture.asset('res/drawables/ic_feedback.svg',
                  width: 36.0, height: 36.0),
              title: Text(S.of(context).navFeedback),
              onTap: () {
                _onNavItemClicked(Strings.NAV_FEEDBACK);
              }),
          Divider(color: Colors.blueGrey),
          ListTile(
              leading: SvgPicture.asset("res/drawables/ic_about.svg",
                  width: 36.0, height: 36.0),
              title: Text(S.of(context).navAbout),
              onTap: () {
                _onNavItemClicked(Strings.NAV_ABOUT);
              })
        ],
      ),
    );
  }

  void _checkLogin() {
    if (UserUtil.getInstance().loginUser == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return LoginPage();
      })).then((value) {
        setState(() {});
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return UserInfoPage();
      }));
    }
  }
}
