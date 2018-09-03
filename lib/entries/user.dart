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
  bool canceled = false;

  @override
  String toString() {
    return 'User{userName: $userName, password: $password, email: $email, '
        'phone: $phone, address: $address, token: $token, '
        'permission: $permission, canceled: $canceled}';
  }
}
