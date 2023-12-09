// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, prefer_single_quotes, lines_longer_than_80_chars, unnecessary_brace_in_string_interps, unnecessary_cast

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/author_message.dart';
import '../model/message.dart';

class IMessageRepo {
  void queryMessageList(String customerId, String shopName) {}
}

class MessageRepository implements IMessageRepo {
  MessageRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<List<Message>> queryMessageList(
    String customerId,
    String shopName,
  ) async {
    final completer = Completer<List<Message>>();
    const query = '''
          SELECT DISTINCT messages.mess_id as mess_id, messages.mess_text as text, messages.status as status, messages.mess_type as type, messages.create_at as create_at, u.id as id, u.full_name as name
FROM messages 
JOIN users u ON messages.user_id = u.id  
WHERE (messages.user_id = @id AND messages.chatwith = @shopname) OR (u.full_name = @shopname AND messages.chatwith = (SELECT full_name from users WHERE users.id = @id)) ORDER BY create_at DESC;
          ''';
    final params = {
      'id': customerId,
      'shopname': shopName,
    };
    final result = await _db.executor.query(query, substitutionValues: params);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final messages = <Message>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        final authorMessage = AuthorMessage(
          id: row['id'].toString(),
          name: row['name'].toString(),
        );
        messages.add(
          Message(
            author: authorMessage as AuthorMessage,
            createAt: int.parse(row['create_at'].toString()),
            id: row['mess_id'].toString(),
            text: row['text'].toString(),
            status: row['status'].toString(),
            type: row['type'].toString(),
          ),
        );
      }
      completer.complete(messages);
    }
    return completer.future;
  }

  Future<int> addMessage(Message message, String shopname) async {
    final completer = Completer<int>();
    const query = '''
          INSERT INTO messages (user_id, status, create_at, mess_text, mess_type, mess_id, chatwith) 
          VALUES (@user_id, @status, @create_at, @mess_text, @mess_type, @mess_id, @shopname)
        ''';
    final params = {
      'user_id': message.author!.id,
      'status': message.status,
      'create_at': message.createAt,
      'mess_text': message.text,
      'mess_type': message.type,
      'mess_id': message.id,
      'shopname': shopname,
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
}
