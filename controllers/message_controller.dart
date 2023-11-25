// ignore_for_file: unnecessary_cast, lines_longer_than_80_chars

import 'dart:async';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/message.dart';
import '../repository/message_repository.dart';

class MessageController {
  MessageController(this._messageRepository, this._logger);
  final MessageRepository _messageRepository;
  final AppLogger _logger;

  Future<List<Message>> handleListMessage(
    String customerId,
    String shopName,
  ) async {
    final completer = Completer<List<Message>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final messageDb = await _messageRepository.queryMessageList(
        customerId,
        shopName,
      ) as List<Message>;
      completer.complete(messageDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<String> handleAddMessage(Message message, String shopName) async {
    final completer = Completer<String>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _messageRepository.addMessage(message, shopName);
    if (result > 0) {
      const userDb = 'OK';
      completer.complete(userDb);
    }
    return completer.future;
  }
}
