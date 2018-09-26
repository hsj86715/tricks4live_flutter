import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'localizations.dart';

class CustomLocaleDelegate extends LocalizationsDelegate<CustomLocalizations> {
  CustomLocaleDelegate._();

  static CustomLocaleDelegate _delegate;

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<CustomLocalizations> load(Locale locale) {
    return new SynchronousFuture<CustomLocalizations>(
        new CustomLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<CustomLocalizations> old) {
    return false;
  }

  static CustomLocaleDelegate delegate() {
    if (_delegate == null) {
      _delegate = new CustomLocaleDelegate._();
    }
    return _delegate;
  }
}
