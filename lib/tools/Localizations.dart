import 'dart:ui';

import 'package:tricks4live_flutter/values/strings/StringsBase.dart';
import 'package:tricks4live_flutter/values/strings/StringsEN.dart';
import 'package:tricks4live_flutter/values/strings/StringsCN.dart';
import 'package:flutter/material.dart';

class CustomLocalizations {
  final Locale locale;

  ///根据不同 locale.languageCode 加载不同语言对应
  static Map<String, StringsBase> _localizedValues = {
    'en': StringsEN(),
    'zh': StringsCN(),
  };

  CustomLocalizations(this.locale);

  StringsBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 CustomLocalizations
  ///获取对应的 StringsBase
  static CustomLocalizations of(BuildContext context) {
    return Localizations.of(context, CustomLocalizations);
  }
}
