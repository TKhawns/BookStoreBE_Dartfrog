// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../controllers/author_controller.dart';
import '../controllers/book_controller.dart';
import '../controllers/message_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/shop_controller.dart';
import '../controllers/user_controller.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/response.dart';
import '../model/user.dart';
import '../repository/author_repository.dart';
import '../repository/book_repository.dart';
import '../repository/message_repository.dart';
import '../repository/order_repository.dart';
import '../repository/shop_repository.dart';
import '../repository/user_repository.dart';
import '../security/jwt.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(verifyJwt)
      .use(injectionController())
      .use(bookListMiddleware())
      .use(authorListMiddleware())
      .use(orderListMiddleware())
      .use(shopListMidderware())
      .use(messageListMiddleware());
}

Middleware injectionController() {
  return (handler) {
    return handler.use(
      provider<UserController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return UserController(UserRepository(db, logger), logger);
        },
      ),
    );
  };
}

Middleware bookListMiddleware() {
  return (handler) {
    return handler.use(
      provider<BookController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return BookController(BookRepository(db, logger), logger);
        },
      ),
    );
  };
}

Middleware messageListMiddleware() {
  return (handler) {
    return handler.use(
      provider<MessageController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return MessageController(MessageRepository(db, logger), logger);
        },
      ),
    );
  };
}

Middleware orderListMiddleware() {
  return (handler) {
    return handler.use(
      provider<OrderController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return OrderController(OrderRepository(db, logger), logger);
        },
      ),
    );
  };
}

Middleware shopListMidderware() {
  return (handler) {
    return handler.use(
      provider<ShopController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return ShopController(ShopRepository(db, logger), logger);
        },
      ),
    );
  };
}

Middleware authorListMiddleware() {
  return (handler) {
    return handler.use(
      provider<AuthorController>(
        (context) {
          final logger = context.read<AppLogger>();
          final db = context.read<Database>();
          return AuthorController(AuthorRepository(db, logger), logger);
        },
      ),
    );
  };
}

// Thiếu token or token có vấn đề là trả lỗi ngay
Handler verifyJwt(Handler handler) {
  return (context) async {
    try {
      if (context.request.url.toString().startsWith('user/register') ||
          context.request.url.toString().startsWith('user/login') ||
          context.request.url.toString().startsWith('home/booklist') ||
          context.request.url.toString().startsWith('home/authorlist') ||
          context.request.url.toString().startsWith('order/list') ||
          context.request.url.toString().startsWith('order/add') ||
          context.request.url.toString().startsWith('order/count') ||
          context.request.url.toString().startsWith('shop/info') ||
          context.request.url.toString().startsWith('order/update') ||
          context.request.url.toString().startsWith('order/delete') ||
          context.request.url.toString().startsWith('home/search') ||
          context.request.url.toString().startsWith('shop/booklist') ||
          context.request.url.toString().startsWith('user/info') ||
          context.request.url.toString().startsWith('chat/message') ||
          context.request.url.toString().startsWith('order/payment_status') ||
          context.request.url.toString().startsWith('order/dash')) {
        // Forward the request to the respective handler.
        return await handler(context);
      }

      final headers = context.request.headers;
      final authInfo = headers['Authorization'];
      // Header: key = Authorization - value:  Bearer {token}
      // authInfo = Bearer {token}
      if (authInfo == null || !authInfo.startsWith('Bearer ')) {
        return Response(statusCode: HttpStatus.badRequest);
      }

      final token = authInfo.split(' ')[1];
      verifyToken(token);

      // Forward the request to the respective handler.
      final user = decodeToken(token);
      return await handler(context.provide<User>(() => user!));
    } catch (e) {
      print(e);
      return AppResponse().error(HttpStatus.badRequest, e.toString());
    }
  };
}
