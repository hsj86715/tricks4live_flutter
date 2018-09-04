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
