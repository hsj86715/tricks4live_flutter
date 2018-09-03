import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/constants.dart';

class UserInfoUi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserInfoUiState();
  }
}

class UserInfoUiState extends State<UserInfoUi> {
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
    return new SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 8.0),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new CircleAvatar(
                child: Icon(Icons.person, color: Colors.grey, size: 64.0),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text("Nick name:"),
                  new Text("user name")
                ],
              )
            ],
          ),
//          new FutureBuilder(
//              future: _user,
//              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                switch (snapshot.connectionState) {
//                  default:
//                    return
//                }
//              }),
          const Divider(height: 1.0, color: Colors.grey),
//          new ListTile(
//            leading: Icon(Icons.publish, color: Colors.blueAccent),
//            title: new Text("My Subject"),
//            trailing: Icon(
//              Icons.chevron_right,
//              color: Colors.black54,
//            ),
//          )
        ],
      ),
    );
//    return new ListView(
//      children: <Widget>[
//        new FutureBuilder(
//            future: _user,
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              switch (snapshot.connectionState) {
//                default:
//                  return new Row(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      new CircleAvatar(
//                        child:
//                            Icon(Icons.person, color: Colors.grey, size: 64.0),
//                        backgroundColor: Colors.white,
//                      )
//                    ],
//                  );
//              }
//            }),
//        const Divider(color: Colors.grey, height: 1.0),
//        new ListTile(
//          leading: Icon(Icons.publish, color: Colors.blueAccent),
//          title: new Text("My Subject"),
//          trailing: Icon(
//            Icons.chevron_right,
//            color: Colors.black54,
//          ),
//        )
//      ],
//    );
  }
}
