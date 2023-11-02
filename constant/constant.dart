// ignore_for_file: lines_longer_than_80_chars

import '../exception/email_invalid.dart';
import '../exception/fullname_require.dart';
import '../exception/id_require.dart';
import '../exception/insert_record_failed.dart';
import '../exception/pass_required.dart';
import '../exception/record_not_found.dart';
import '../exception/token_invalid.dart';

class ExSql {
  static const statusRecordNotFound = RecordNotFound('Record not found');
  static const insertRecordFailed = InsertRecordFailed('Insert record failed');
}

class ExBus {
  static const emailInvalid = EmailInvalid('Email invalid');
  static const idRequired = IDRequired('id can not be null');
  static const fullNameRequired = FullNameRequired('Full name can not be null');
  static const passwordRequired = PasswordRequired('Full name can not be null');
  static const passwordLength =
      PasswordLength('Passwords must be at least 6 characters');
  static const passwordInCorrect = PasswordInCorrect('Password incorrect');

  static const tokenInvalid = TokenInvalid('Token invalid or expirse');
}

class AppMsg {
  static const msgMethodNotAllow = 'Method not allowed';
}

class AppRequire {
  static const lengthPass = 6;
}

class AppConfig {
  static const jwtSecretKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTY3NDk5NzA2NywiaWF0IjoxNjc0OTk3MDY3fQ.B7MZDAIYi3ClKkq3I0TAumROflUMwW2h5Cy2KutGoAc';
}
