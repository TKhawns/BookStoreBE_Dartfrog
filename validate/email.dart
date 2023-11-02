import 'dart:core';
import 'strings.dart';

bool isValidEmail(String? email) {
  if (isNullOrEmpty(email)) {
    return false;
  }
  return true;
}
