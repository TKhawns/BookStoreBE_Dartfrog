// ignore_for_file: directives_ordering

import 'dart:async';
import '../constant/constant.dart';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../security/jwt.dart';
import '../security/pass.dart';
import '../validate/email.dart';
import '../validate/pass.dart';
import '../validate/strings.dart';
import 'package:uuid/uuid.dart';

class UserController {
  UserController(this._userRepository, this._logger);
  final UserRepository _userRepository;
  final AppLogger _logger;

  Future<User> handleLogin(String? email, String password) async {
    final completer = Completer<User>();
    final errMsgList = <String>[];

    if (!isValidEmail(email)) {
      _logger.log.info(ExBus.emailInvalid.toString());
      completer.completeError(ExBus.emailInvalid);
      return completer.future;
    }

    if (isNullOrEmpty(password)) {
      errMsgList.add(ExBus.passwordRequired.toString());
    }

    if (!isValidPass(password)) {
      errMsgList.add(ExBus.passwordLength.toString());
    }

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final userDb =
          await _userRepository.findUserByEmail(email, showPass: true);

      // check pass
      if (verifyPass(password, userDb.password!)) {
        userDb.token = genToken(userDb);
        completer.complete(userDb);
      } else {
        completer.completeError(ExBus.passwordInCorrect);
      }
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<User> handleFindUserByEmail(String? email) {
    final completer = Completer<User>();
    if (!isValidEmail(email)) {
      _logger.log.info(ExBus.emailInvalid.toString());
      completer.completeError(ExBus.emailInvalid);
      return completer.future;
    }

    final user = _userRepository.findUserByEmail(email);
    completer.complete(user);

    return completer.future;
  }

  Future<User> getUserInfo(String? customerId) async {
    final completer = Completer<User>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final userDb = await _userRepository.getUserInfo(customerId);
      completer.complete(userDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<User> handleFindUserByID(String? id) {
    final completer = Completer<User>();
    if (isNullOrEmpty(id)) {
      _logger.log.info(ExBus.idRequired.toString());
      completer.completeError(ExBus.idRequired);
      return completer.future;
    }

    final user = _userRepository.findUserByID(id);
    completer.complete(user);

    return completer.future;
  }

  Future<List<User>> handleUserChat(String customerId) async {
    final completer = Completer<List<User>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final orderDb =
          await _userRepository.getUserChat(customerId) as List<User>;
      completer.complete(orderDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<User> handleRegisterAcc(User user) async {
    final completer = Completer<User>();
    final errMsgList = <String>[];

    if (!isValidEmail(user.phone)) {
      errMsgList.add(ExBus.emailInvalid.toString());
    }

    if (isNullOrEmpty(user.fullName)) {
      errMsgList.add(ExBus.fullNameRequired.toString());
    }

    if (isNullOrEmpty(user.password)) {
      errMsgList.add(ExBus.passwordRequired.toString());
    }

    if (!isValidPass(user.password)) {
      errMsgList.add(ExBus.passwordLength.toString());
    }

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // generate id
    const uuid = Uuid();
    user.id = uuid.v4();

    // generate password
    // ignore: cascade_invocations
    user.password = genPass(user.password!);

    final result = await _userRepository.saveUser(user);
    if (result > 0) {
      final userDb = await _userRepository.findUserByEmail(user.phone);
      userDb.token = genToken(userDb);
      completer.complete(userDb);
    }
    return completer.future;
  }
}
