import 'package:tricks4live_flutter/entries/User.dart';

class UserUtil {
  UserUtil._();

  static UserUtil _instance;

  static UserUtil getInstance() {
    if (_instance == null) {
      _instance = new UserUtil._();
    }
    return _instance;
  }

  User _loginUser;

  User get loginUser => _loginUser;

  set loginUser(User value) => _loginUser = value;

  static User parseUser(Map<String, dynamic> userJson) {
    User user = User();
    user.id = userJson['id'];
    user.userName = userJson['userName'];
    user.nickName = userJson['nickName'];
    user.email = userJson['email'];
    user.phone = userJson['phone'];
    user.address = userJson['address'];
    user.token = userJson['token'];
    user.avatar = userJson['avatar'];
    user.permission = userJson['permission'];
    return user;
  }

  bool userHasLogin() {
    return _loginUser != null;
  }

  bool hasPermission(int permission) {
    print(_loginUser.toString());
    return (_loginUser.permission & permission) != 0;
  }
}
