import 'package:flutter/material.dart';
import 'home_drawer.dart';
import 'home_body.dart';
import 'user_info.dart';

class Tricks4LiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tricks4Live",
      theme: ThemeData(primaryColor: const Color(0xff283593)),
      home: AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Tricks4Live')),
        drawer: HomeDrawerUi(_scaffoldKey),
        body: HomeBody());
  }
}
