import 'package:flutter/material.dart';
import 'package:tricks4live/pages/HomeDrawer.dart';
import 'package:tricks4live/pages/HomeBody.dart';
import 'package:tricks4live/redux/AppState.dart';
import 'package:tricks4live/entries/User.dart';
import 'package:tricks4live/generated/i18n.dart';
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
                S.delegate
              ],
//              locale: store.state.locale,
              supportedLocales: S.delegate.supportedLocales,
//              theme: store.state.themeData,
          theme: ThemeData(primarySwatch: Colors.lime),
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
        appBar: AppBar(title: Text(S.of(context).appName)),
        drawer: HomeDrawerUi(),
        body: HomeBody());
  }
}
