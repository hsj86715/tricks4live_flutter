import 'package:flutter/material.dart';
import 'package:tricks4live/entries/User.dart';
import 'package:tricks4live/redux/UserRedux.dart';
import 'package:tricks4live/redux/ThemeDataRedux.dart';
import 'package:tricks4live/redux/LanguageRedux.dart';

class AppState {
  User userInfo;

  ThemeData themeData;

  Locale locale;

  AppState({this.userInfo, this.themeData, this.locale});
}

AppState appReducer(AppState state, action) {
  return AppState(
      userInfo: UserReducer(state.userInfo, action),
      themeData: ThemeDataReducer(state.themeData, action),
      locale: LocaleReducer(state.locale, action));
}
