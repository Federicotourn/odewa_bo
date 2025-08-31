// import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoggedUserService extends GetxService {
  final box = GetStorage('User');
  // final TokenValidationService _tokenValidationService =
  //     Get.find<TokenValidationService>();

  Future<LoggedUserService> init() async {
    return this;
  }
}
