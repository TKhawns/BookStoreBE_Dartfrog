// ignore_for_file: unnecessary_cast

import 'dart:async';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/author.dart';
import '../repository/author_repository.dart';

class AuthorController {
  AuthorController(this._authorRepository, this._logger);
  final AuthorRepository _authorRepository;
  final AppLogger _logger;

  Future<List<Author>> handleListAuthor() async {
    final completer = Completer<List<Author>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final authorDb =
          await _authorRepository.queryAuthorList() as List<Author>;
      completer.complete(authorDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
