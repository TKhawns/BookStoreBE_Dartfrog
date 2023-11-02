import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';

import '../../controllers/book_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final bookController = context.read<BookController>();
  try {
    final bookDb = await bookController.handleListBook();
    return AppResponse().ok(HttpStatus.ok, bookDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
