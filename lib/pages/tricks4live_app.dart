import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_drawer.dart';
import 'home_body.dart';
import '../tools/localization_delegate.dart';
import '../tools/common_utils.dart';

class Tricks4LiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocaleDelegate.delegate()
      ],
      locale: Locale('zh'),
      supportedLocales: [Locale('zh'), Locale('en')],
//      title: CommonUtils.getLocale(context).appName,
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
        appBar: AppBar(title: Text(CommonUtils.getLocale(context).appName)),
        drawer: HomeDrawerUi(_scaffoldKey),
        body: HomeBody());
  }
}
