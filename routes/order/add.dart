// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/order_controller.dart';
import '../../model/book.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final orderController = context.read<OrderController>();
  // Access the request body as parsed `JSON`.
  final body = await context.request.json();
  final orderReq = Book(
    book_id: body['order_id'].toString(),
    title: body['title'].toString(),
    description: body['description'].toString(),
    price: body['price'].toString(),
    shipcost: body['shipcost'].toString(),
    image: body['image'].toString(),
    number_books: body['number_books'].toString(),
    shopName: body['shopname'].toString(),
    score: body['score'].toString(),
    shop_image: body['shop_image'].toString(),
    authorName: body['authorname'].toString(),
    quantity: body['quantity'].toString(),
  );

  try {
    final order = await orderController.handleAddOrder(orderReq);
    return AppResponse().ok(HttpStatus.ok, order);
  } catch (e) {
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
