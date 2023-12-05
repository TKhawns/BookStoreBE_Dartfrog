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

  Future<dynamic> handleAddOrder(Book book, String customerId) async {
    final completer = Completer<dynamic>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.addBook(book, customerId);
    if (result > 0) {
      final userDb = await _orderRepository.countOrder(customerId);
      completer.complete(userDb);
    }
    return completer.future;
  }

  Future<List<Book>> handleUpdateOrder(Book book, String customerId) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.updateOrder(
      book.quantity,
      book.book_id,
      customerId,
    );
    if (result > 0) {
      final userDb = await _orderRepository.queryBookList(customerId);
      completer.complete(userDb);
    }
    return completer.future;
  }

  Future<String> handleConfirmOrder() async {
    final completer = Completer<String>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.confirmOrder();
    if (result > 0) {
      completer.complete('Confirm ok');
    }
    return completer.future;
  }

  Future<String> handleSetPaymentStatus(String customerId) async {
    final completer = Completer<String>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.setPaymentStatus(customerId);
    if (result > 0) {
      completer.complete('Set Payment Status ok');
    }
    return completer.future;
  }

  Future<List<Book>> handleDeleteOrder(Book book, String customerId) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    // o day, dang set api tra ve phan tu dau tien trong list order de xac thuc duoc la call api thanh cong
    final result = await _orderRepository.deleteOrder(book.book_id, customerId);
    if (result > 0) {
      final userDb = await _orderRepository.queryBookList(customerId);
      completer.complete(userDb);
    }
    return completer.future;
  }

  Future<List<Book>> handleOrderBook(String customerId) async {
    final completer = Completer<List<Book>>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final orderDb =
          await _orderRepository.queryBookList(customerId) as List<Book>;
      completer.complete(orderDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<dynamic> handeCountOrder(String id) async {
    final completer = Completer<dynamic>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final countDb = await _orderRepository.countOrder(id);
      completer.complete(countDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<dynamic> getDataDash(String id) async {
    final completer = Completer<dynamic>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final countDb = await _orderRepository.getDataDash(id);
      completer.complete(countDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
