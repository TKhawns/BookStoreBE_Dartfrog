import '../constant/constant.dart';
import 'strings.dart';

bool isValidPass(String? pass) {
  if (isNullOrEmpty(pass)) {
    return false;
  }

  if (pass!.length < AppRequire.lengthPass) {
    return false;
  }

  return true;
}
