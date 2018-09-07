import 'package:flutter/material.dart';
import 'home_drawer.dart';
import 'home_body.dart';
import 'user_info.dart';

class Tricks4LiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Tricks4Live",
      theme: new ThemeData(primaryColor: const Color(0xff283593)),
      home: new AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Tricks4Live'),
      ),
      drawer: new HomeDrawerUi(_scaffoldKey),
      body: new HomeBody(),
    );
  }
}
