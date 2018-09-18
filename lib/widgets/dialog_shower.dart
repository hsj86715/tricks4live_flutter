import 'package:flutter/material.dart';

enum DialogAction {
  cancel,
  ok,
  edit,
  login,
  retry,
}

typedef void ActionClicked(value);

showCustomDialog<T>({@required BuildContext context, @required Widget child, ActionClicked action}) {
  showDialog<T>(context: context, builder: (BuildContext context) => child)
      .then(action);
}
