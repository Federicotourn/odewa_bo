import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/controllers/menu_controller.dart';
import 'package:odewa_bo/helpers/cookie_manager.dart';
import 'package:odewa_bo/pages/authentication/services/auth_service.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:odewa_bo/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class TokenValidationService extends GetxService {
  final box = GetStorage('User');

  Future<TokenValidationService> init() async {
    return this;
  }

  final client = RetryClient(
    http.Client(),
    retries: 1,
    when: (response) {
      return response.statusCode == 401;
    },
    onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        bool result = await TokenValidationService().refreshToken();
        if (result) {
          req.headers.remove('Authorization');
          final box = GetStorage('User');
          String token = box.read('token');

          Map<String, String> tokenHeader = {'Authorization': 'Bearer $token'};
          req.headers.addEntries(tokenHeader.entries);
        } else {
          await TokenValidationService().logout();
        }
      } else if (retryCount == 1 && res?.statusCode == 401) {
        await TokenValidationService().logout();
      }
    },
  );

  Future<void> logout() async {
    final authService = Get.find<AuthService>();
    loading(Get.context!);
    await authService.logout();
    final menuController = Get.find<MenuController>();
    menuController.changeActiveItemTo(overViewPageDisplayName);
    final box = GetStorage('User');
    box.remove('user');
    box.remove('token');
    CookieManager().removeCookie(Constants.cookieName);
    final loggedUserController = Get.find<LoggedUserController>();
    loggedUserController.clearCookies();
    Get.delete<LoggedUserController>();
    Get.back();
    Get.offAllNamed(authenticationPageRoute);
  }

  Future<bool> refreshToken() async {
    // LoginData user = loginFromJson(box.read('user'));
    // final Uri url = Uri.parse('${Urls.baseUrl}/v1/auth/refresh');

    // Map<String, String> headers = {
    //   'Authorization': 'Bearer ${user.refreshToken}',
    // };
    // var response = await http.get(url, headers: headers);

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> dataParsed = json.decode(response.body);
    //   String token = dataParsed['token'];
    //   String refreshToken = dataParsed['refreshToken'];
    //   await box.write('token', token);
    //   user.refreshToken = refreshToken;
    //   await box.write('user', loginToJson(user));
    //   return true;
    // }
    // return false;
    return true;
  }
}
