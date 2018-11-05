import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tricks4live_flutter/pages/HomeDrawer.dart';
import 'package:tricks4live_flutter/pages/HomeBody.dart';
import 'package:tricks4live_flutter/tools/LocalizationDelegate.dart';
import 'package:tricks4live_flutter/tools/CommonUtils.dart';
import 'package:tricks4live_flutter/redux/AppState.dart';
import 'package:tricks4live_flutter/entries/User.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new Tricks4LiveApp());

class Tricks4LiveApp extends StatelessWidget {
  final store = new Store<AppState>(appReducer,
      initialState: AppState(
          userInfo: User.empty(),
          themeData: ThemeData.light(),
          locale: Locale('en')));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<AppState>(builder: (context, store) {
          return MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                CustomLocaleDelegate.delegate()
              ],
              locale: store.state.locale,
              supportedLocales: [store.state.locale],
              theme: store.state.themeData,
              home: AppHome());
        }));
  }
}

class AppHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(CommonUtils.getLocale(context).appName)),
        drawer: HomeDrawerUi(),
        body: HomeBody());
  }
}
