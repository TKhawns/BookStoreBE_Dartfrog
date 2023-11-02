import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/user_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/response.dart';
import '../../model/user.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final userController = context.read<UserController>();
  final user = context.read<User>();

  try {
    final userDb = await userController.handleFindUserByID(user.id);
    return AppResponse().ok(HttpStatus.ok, userDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
