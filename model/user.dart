class User {
  User({
    this.id,
    this.fullName,
    this.phone,
    this.role,
    this.password,
    this.avatar,
    this.address,
  });
  String? id;
  String? fullName;
  String? phone;
  String? password;
  String? role;
  String? token;
  String? avatar;
  String? address;

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': phone,
        'role': role,
        'token': token,
        'avatar': avatar,
        'address': address,
      };

  @override
  String toString() {
    return '''
      {id = $id, fullName = $fullName, email = $phone, 
      role = $role password = $password, token = $token, avatar = $avatar, address = $address}
      ''';
  }
}
