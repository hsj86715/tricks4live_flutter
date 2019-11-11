import 'Constants.dart';
import 'package:flutter/material.dart';
import 'package:tricks4live/generated/i18n.dart';

class CommonUtils {
  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 19) {//yyyy-MM-dd hh:mm:ss
      return date.toString();
    }
    return date.toString().substring(0, 19);
  }

  ///日期格式转换
  static String getNewsTimeStr(DateTime date, BuildContext context) {
    if (date == null || date.toString() == null) {
      return "";
    }
    int subTime =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTime < Numbers.MILLIS_LIMIT) {
      return S.of(context).timeMillisLimit;
    } else if (subTime < Numbers.SECONDS_LIMIT) {
      return (subTime / Numbers.MILLIS_LIMIT).round().toString() +
          S.of(context).timeSecondsLimit;
    } else if (subTime < Numbers.MINUTES_LIMIT) {
      return (subTime / Numbers.SECONDS_LIMIT).round().toString() +
          S.of(context).timeMinutesLimit;
    } else if (subTime < Numbers.HOURS_LIMIT) {
      return (subTime / Numbers.MINUTES_LIMIT).round().toString() +
          S.of(context).timeHoursLimit;
    } else if (subTime < Numbers.WEEK_LIMIT) {
      return (subTime / Numbers.HOURS_LIMIT).round().toString() +
          S.of(context).timeDaysLimit;
    }else if(subTime<Numbers.MONTH_LIMIT){
      return (subTime / Numbers.WEEK_LIMIT).round().toString() +
          S.of(context).timeWeeksLimit;
    } else {
      return getDateStr(date);
    }
  }

}
