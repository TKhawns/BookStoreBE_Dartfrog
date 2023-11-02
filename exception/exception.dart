abstract class AppException implements Exception {
  const AppException(this.message);
  // ignore: unused_field
  final String message;

  @override
  String toString() {
    return message;
  }
}
