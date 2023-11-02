// ignore_for_file: avoid_dynamic_calls

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../constant/constant.dart';
import '../exception/exception.dart';
import '../model/user.dart';

String genToken(User user) {
  final jwt = JWT(
    {
      'id': user.id,
      'fullName': user.fullName,
      'email': user.phone,
      'exp':
          DateTime.now().add(const Duration(hours: 100)).millisecondsSinceEpoch,
    },
  );

  // Sign it (default with HS256 algorithm)
  return jwt.sign(SecretKey(AppConfig.jwtSecretKey));
}

User? decodeToken(String token) {
  try {
    final jwt = JWT.verify(token, SecretKey(AppConfig.jwtSecretKey));
    return User(
      id: jwt.payload['id'].toString(),
      phone: jwt.payload['email'].toString(),
      fullName: jwt.payload['fullName'].toString(),
    );
  } catch (e) {
    throw ExBus.tokenInvalid;
  }
}

AppException? verifyToken(String token) {
  try {
    JWT.verify(token, SecretKey(AppConfig.jwtSecretKey));
    return null;
  } catch (e) {
    return ExBus.tokenInvalid;
  }
}
