class UserSimple {
  int id;
  String nickName;
  String avatar;

  @override
  String toString() {
    return 'UserSimple{id: $id, nickName: $nickName, avatar: $avatar}';
  }
}

class User extends UserSimple {
  String userName;
  String password;
  String email;
  String phone;
  String address;
  String token;
  int permission;

  @override
  String toString() {
    return 'User{id: $id, nickName: $nickName, avatar: $avatar, userName: $userName, '
        'password: $password, email: $email, phone: $phone, address: $address, '
        'token: $token, permission: $permission}';
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'nickName': nickName,
        'password': password,
        'phone': phone,
        'avatar': avatar,
        'email': email,
        'address': address,
      };
}

class Permission {
  static const int NONE = 1;//通过注册产生的用户，无任何权限，可以登录，浏览，需要邮箱验证
  static const int BASE = NONE << 1;//需要邮箱验证，点赞，取消赞，评论，改进
  static const int VERIFIER = NONE << 2;//验证员
  static const int CAT_THIRD = NONE << 3;//3级分类下管理
  static const int CAT_SECOND = NONE << 4;//2级分类下管理
  static const int CAT_FIRST = NONE << 5;//1级分类下管理
  static const int SYSTEM_SUB = NONE << 6;//后台子管理用户
  static const int SYSTEM_MAIN = NONE << 7;//后台主管理用户
  static const int SYSTEM_ROOT = NONE << 8;//系统超级管理，上帝
}