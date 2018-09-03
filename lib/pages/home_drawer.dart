import 'dart:async';
import 'package:flutter/material.dart';
import '../tools/constants.dart';
import 'login_user.dart';
import 'user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DrawerState();
  }
}

class _DrawerState extends State<HomeDrawer> {
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
                          : _userLogin[0]),
                      accountEmail:
                          new Text(_userLogin == null ? "" : _userLogin[1]),
                      currentAccountPicture: new CircleAvatar(
                        child:
                            Icon(Icons.person, color: Colors.grey, size: 64.0),
                        backgroundColor: Colors.white,
                      ),
                      onDetailsPressed: _checkLogin,
                    );
                }
              }),
          new ListTile(
            leading: new Icon(Icons.home, color: Colors.blue),
            title: new Text(Strings.NAV_HOME),
            onTap: () {
              _onNavItemClicked(Strings.NAV_HOME);
            },
          ),
          new Divider(color: Colors.blueGrey),
          new ListTile(
            leading: new Icon(Icons.share, color: Colors.blue),
            title: new Text(Strings.NAV_SHARE),
            onTap: () {
              _onNavItemClicked(Strings.NAV_SHARE);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.feedback, color: Colors.blue),
            title: new Text(Strings.NAV_FEEDBACK),
            onTap: () {
              _onNavItemClicked(Strings.NAV_FEEDBACK);
            },
          ),
          new Divider(color: Colors.blueGrey),
          new ListTile(
            leading: new Icon(Icons.new_releases, color: Colors.blue),
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
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Login'),
          ),
          body: new LoginUi(),
        );
      }));
    } else {}
  }
}
