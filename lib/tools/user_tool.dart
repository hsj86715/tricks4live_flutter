import '../entries/user.dart';

class UserUtil {
  static User loginUser;

  static User parseUser(Map<String, dynamic> userJson) {
    User user = new User();
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

  static bool userHasLogin() {
    return loginUser != null;
  }

  static bool hasPermission(int permission) {
    return (loginUser.permission & permission) != 0;
  }
}
