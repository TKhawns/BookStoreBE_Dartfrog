import 'exception.dart';

class PasswordRequired extends AppException {
  const PasswordRequired(super.message);
}

class PasswordLength extends AppException {
  const PasswordLength(super.message);
}

class PasswordInCorrect extends AppException {
  const PasswordInCorrect(super.message);
}
