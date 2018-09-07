import 'dart:async';
import 'package:flutter/material.dart';
import '../tools/constants.dart';
import 'login_user.dart';
import 'user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeDrawerUi extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  HomeDrawerUi(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return new _HomeDrawerUiState();
  }
}

class _HomeDrawerUiState extends State<HomeDrawerUi> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> _user;
  List<String> _userLogin;

  _onNavItemClicked(String itemName) {
    print(itemName);
  }

  @override
  void initState() {
    super.initState();
    _user = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList(Strings.PREFS_KEY_LOGIN_USER);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new FutureBuilder(
              future: _user,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (!snapshot.hasError) {
                      print(snapshot.data);
                      _userLogin = snapshot.data;
                    }
                    return new UserAccountsDrawerHeader(
                      accountName: new Text(_userLogin == null
                          ? 'Click to login'
                          : _userLogin[1]),
                      accountEmail:
                          new Text(_userLogin == null ? "" : _userLogin[2]),
                      currentAccountPicture: new SvgPicture.asset(
                        'assets/icons/ic_avatar.svg',
                        width: 120.0,
                        height: 120.0,
                      ),
                      onDetailsPressed: _checkLogin,
                    );
                }
              }),
          new ListTile(
            leading: SvgPicture.asset('assets/icons/ic_home.svg',
                width: 36.0, height: 36.0),
            title: new Text(Strings.NAV_HOME),
            onTap: () {
              _onNavItemClicked(Strings.NAV_HOME);
            },
          ),
          new Divider(color: Colors.blueGrey),
          new ListTile(
            leading: SvgPicture.asset('assets/icons/ic_share.svg',
                width: 36.0, height: 36.0),
            title: new Text(Strings.NAV_SHARE),
            onTap: () {
              _onNavItemClicked(Strings.NAV_SHARE);
            },
          ),
          new ListTile(
            leading: SvgPicture.asset('assets/icons/ic_feedback.svg',
                width: 36.0, height: 36.0),
            title: new Text(Strings.NAV_FEEDBACK),
            onTap: () {
              _onNavItemClicked(Strings.NAV_FEEDBACK);
            },
          ),
          new Divider(color: Colors.blueGrey),
          new ListTile(
            leading: SvgPicture.asset("assets/icons/ic_about.svg",
                width: 36.0, height: 36.0),
            title: new Text(Strings.NAV_ABOUT),
            onTap: () {
              _onNavItemClicked(Strings.NAV_ABOUT);
            },
          )
        ],
      ),
    );
  }

  void _checkLogin() {
    if (_userLogin == null) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new LoginPage();
      })).then((value) {
        print(value.toString());
        _userLogin = value;
        setState(() {});
      });
    } else {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new UserInfoPage();
      }));
    }
  }
}
