import 'package:get/get.dart';

class AuthController extends GetxController {
  String? name;
  String? surname;
  bool isModerator = false;

  void erase() {
    name = null;
    surname = null;
    isModerator = false;
  }
}
