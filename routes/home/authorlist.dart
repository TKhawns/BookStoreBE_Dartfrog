import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';

import '../../controllers/author_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final authorController = context.read<AuthorController>();
  try {
    final authorDb = await authorController.handleListAuthor();
    return AppResponse().ok(HttpStatus.ok, authorDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
