// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, lines_longer_than_80_chars

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/author.dart';

class IAuthorRepo {
  Future<int>? saveAuthor(Author author) {}
  void queryAuthorList() {}
}

class AuthorRepository implements IAuthorRepo {
  AuthorRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<int> saveAuthor(Author author) async {
    final completer = Completer<int>();
    return completer.future;
  }

  @override
  Future<List<Author>> queryAuthorList() async {
    final completer = Completer<List<Author>>();
    const query = 'SELECT * FROM author;';
    final result = await _db.executor.query(query);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        'no result',
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final authors = <Author>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        authors.add(
          Author(
            author_id: row['author_id'].toString(),
            full_name: row['full_name'].toString(),
            description: row['description'].toString(),
            image: row['image'].toString(),
            number_books: row['number_books'].toString(),
            link_youtube: row['link_youtube'].toString(),
          ),
        );
      }
      completer.complete(authors);
    }
    return completer.future;
  }
}
