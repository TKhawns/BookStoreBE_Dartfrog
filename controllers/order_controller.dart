// ignore_for_file: null_argument_to_non_null_type, unnecessary_cast, lines_longer_than_80_chars

import 'dart:async';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../repository/order_repository.dart';

class OrderController {
  OrderController(this._orderRepository, this._logger);
  final OrderRepository _orderRepository;
  final AppLogger _logger;

  Future<Book> handleAddOrder(Book book) async {
    final completer = Completer<Book>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.addBook(book);
    if (result > 0) {
      final userDb = await _orderRepository.queryBookList();
      completer.complete(userDb[0]);
    }
    return completer.future;
  }

  Future<List<Book>> handleUpdateOrder(Book book) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result =
        await _orderRepository.updateOrder(book.quantity, book.book_id);
    if (result > 0) {
      final userDb = await _orderRepository.queryBookList();
      completer.complete(userDb);
    }
    return completer.future;
  }

  Future<List<Book>> handleDeleteOrder(Book book) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.deleteOrder(book.book_id);
    if (result > 0) {
      final userDb = await _orderRepository.queryBookList();
      completer.complete(userDb);
    }
    return completer.future;
  }

  Future<List<Book>> handleOrderBook() async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final orderDb = await _orderRepository.queryBookList() as List<Book>;
      completer.complete(orderDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<dynamic> handeCountOrder() async {
    final completer = Completer<dynamic>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final countDb = await _orderRepository.countOrder();
      completer.complete(countDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
