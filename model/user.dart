class User {
  User({this.id, this.fullName, this.phone, this.role, this.password});
  String? id;
  String? fullName;
  String? phone;
  String? password;
  String? role;
  String? token;

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': phone,
        'role': role,
        'token': token,
      };

  @override
  String toString() {
    return '''
      {id = $id, fullName = $fullName, email = $phone, 
      role = $role password = $password, token = $token}
      ''';
  }
}
