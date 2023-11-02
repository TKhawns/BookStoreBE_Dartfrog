// ignore_for_file: unnecessary_cast

import 'dart:async';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../repository/book_repository.dart';

class BookController {
  BookController(this._bookRepository, this._logger);
  final BookRepository _bookRepository;
  final AppLogger _logger;

  Future<List<Book>> handleListBook() async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final bookDb = await _bookRepository.queryBookList() as List<Book>;
      completer.complete(bookDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<List<Book>> handleSearchBook(String? title) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final bookDb = await _bookRepository.searchBookList(title) as List<Book>;
      completer.complete(bookDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
