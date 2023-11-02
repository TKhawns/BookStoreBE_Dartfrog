// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/user_controller.dart';
import '../../model/response.dart';
import '../../model/user.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final userController = context.read<UserController>();
  // Access the request body as parsed `JSON`.
  final body = await context.request.json();
  final userReq = User(
    fullName: body['full_name'].toString(),
    phone: body['email'].toString(),
    password: body['password'].toString(),
  );

  try {
    final user = await userController.handleRegisterAcc(userReq);
    return AppResponse().ok(HttpStatus.ok, user);
  } catch (e) {
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
