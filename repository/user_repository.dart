// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';

import '../constant/constant.dart';
import '../constant/role.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/user.dart';

// class to register account and find user by phone and id
class IUserRepo {
  Future<int>? saveUser(User user) {}
  void findUserByEmail(String? phone, {bool? showPass}) {}
  void findUserByID(String? phone, {bool? showPass}) {}
  Future<User>? getUserInfo(String? customerId) {}
}

class UserRepository implements IUserRepo {
  UserRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<int> saveUser(User user) async {
    _logger.log.info('register >> user = $user()');

    final completer = Completer<int>();
    const query = '''
          INSERT INTO users (id, full_name, email, password, role, avatar, address) 
          VALUES (@id, @full_name, @email, @password, @role, @avatar, @address)
        ''';
    final params = {
      'id': user.id,
      'full_name': user.fullName,
      'email': user.phone,
      'password': user.password,
      'role': Role.member.name,
      'avatar':
          'https://i.pinimg.com/236x/f7/73/8d/f7738dbb19d719f32ab30aec55cb0cb1.jpg',
      'address': 'Ha Noi',
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.affectedRowCount == 0) {
      completer.completeError(ExSql.insertRecordFailed);
    }

    _logger.debugSql(query, params, message: '{$result.affectedRowCount}');

    completer.complete(result.affectedRowCount);
    return completer.future;
  }

  @override
  Future<User> findUserByEmail(String? phone, {bool? showPass = false}) async {
    _logger.log.info('findUserByEmail >> email = $phone');

    final completer = Completer<User>();
    const query = 'SELECT * FROM users where email = @email';
    final params = {'email': phone};
    final result = await _db.executor.query(query, substitutionValues: params);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        params,
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    }

    final firstRow = result.first.toColumnMap();
    completer.complete(
      User(
        id: firstRow['id'].toString(),
        fullName: firstRow['full_name'].toString(),
        phone: firstRow['email'].toString(),
        role: firstRow['role'].toString(),
        password: showPass! ? firstRow['password'].toString() : null,
        avatar: firstRow['avatar'].toString(),
        address: firstRow['address'].toString(),
      ),
    );
    _logger.debugSql(query, params, result: firstRow);

    return completer.future;
  }

  @override
  Future<User> findUserByID(String? id, {bool? showPass = false}) async {
    _logger.log.info('findUserByID >> id = $id');

    final completer = Completer<User>();
    const query = 'SELECT * FROM users where id = @id';
    final params = {'id': id};
    final result = await _db.executor.query(query, substitutionValues: params);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        params,
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    }

    final firstRow = result.first.toColumnMap();
    completer.complete(
      User(
        id: firstRow['id'].toString(),
        fullName: firstRow['full_name'].toString(),
        phone: firstRow['email'].toString(),
        role: firstRow['role'].toString(),
        password: showPass! ? firstRow['password'].toString() : null,
        avatar: firstRow['avatar'].toString(),
        address: firstRow['address'].toString(),
      ),
    );
    _logger.debugSql(query, params, result: firstRow);

    return completer.future;
  }

  @override
  Future<User> getUserInfo(String? customerId) async {
    final completer = Completer<User>();
    const query = '''
          SELECT * FROM users WHERE id = @customer_id ;
        ''';
    final params = {
      'customer_id': customerId,
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        params,
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    }

    final firstRow = result.first.toColumnMap();
    completer.complete(
      User(
        id: firstRow['id'].toString(),
        fullName: firstRow['full_name'].toString(),
        phone: firstRow['email'].toString(),
        role: firstRow['role'].toString(),
        avatar: firstRow['avatar'].toString(),
        address: firstRow['address'].toString(),
      ),
    );
    _logger.debugSql(query, params, result: firstRow);

    return completer.future;
  }
}
