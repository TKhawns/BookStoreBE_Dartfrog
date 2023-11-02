// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/book_controller.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final bookController = context.read<BookController>();
  // Access the request body as parsed `JSON`.
  final body = await context.request.json();
  final bookReq = body['title'].toString();

  try {
    final book = await bookController.handleSearchBook(bookReq);
    return AppResponse().ok(HttpStatus.ok, book);
  } catch (e) {
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
