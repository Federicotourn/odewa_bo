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

/// Cliente HTTP personalizado que intercepta respuestas 401
class AuthInterceptorClient extends http.BaseClient {
  final http.Client _inner;
  final TokenValidationService _tokenService;

  AuthInterceptorClient(this._inner, this._tokenService);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);
    
    // Interceptar respuestas 401
    if (response.statusCode == 401) {
      // Verificar si es una ruta de autenticación para evitar loops
      final uri = request.url.toString();
      if (!uri.contains('/auth/login') && !uri.contains('/auth/client/login')) {
        // Llamar al logout de forma asíncrona para no bloquear
        _handleUnauthorized();
      }
    }
    
    return response;
  }

  void _handleUnauthorized() {
    // Usar un microtask para evitar problemas de contexto y no bloquear la respuesta
    Future.microtask(() async {
      // Llamar al método de logout mejorado que maneja todos los casos
      await _tokenService.handleUnauthorized();
    });
  }

  @override
  void close() {
    _inner.close();
  }
}

class TokenValidationService extends GetxService {
  final box = GetStorage('User');
  late final http.Client _baseClient;
  late final http.Client _retryClient;
  late final http.Client client;

  Future<TokenValidationService> init() async {
    _baseClient = http.Client();
    _retryClient = RetryClient(
      _baseClient,
      retries: 1,
      when: (response) {
        return response.statusCode == 401;
      },
      onRetry: (req, res, retryCount) async {
        // Este método se ejecuta cuando hay un 401
        // El interceptor también capturará el 401, pero aquí intentamos refrescar el token primero
        if (retryCount == 0 && res?.statusCode == 401) {
          bool result = await refreshToken();
          if (result) {
            req.headers.remove('Authorization');
            final box = GetStorage('User');
            String? token = box.read('token');
            if (token != null) {
              Map<String, String> tokenHeader = {'Authorization': 'Bearer $token'};
              req.headers.addEntries(tokenHeader.entries);
            } else {
              // Si no hay token después del refresh, forzar logout
              await _forceLogout();
            }
          } else {
            // Si el refresh falla, forzar logout
            await _forceLogout();
          }
        } else if (retryCount == 1 && res?.statusCode == 401) {
          // Si después del retry sigue siendo 401, forzar logout
          await _forceLogout();
        }
      },
    );
    // Envolver el RetryClient con el interceptor para capturar todos los 401
    client = AuthInterceptorClient(_retryClient, this);
    return this;
  }

  /// Método público para manejar 401 - puede ser llamado desde el interceptor
  Future<void> handleUnauthorized() async {
    await _forceLogout();
  }

  /// Método mejorado de logout que no depende del contexto
  Future<void> _forceLogout() async {
    try {
      // Limpiar datos locales primero
      final box = GetStorage('User');
      box.remove('user');
      box.remove('token');
      CookieManager().removeCookie(Constants.cookieName);

      // Intentar hacer logout en el servidor (puede fallar si ya no hay sesión)
      try {
        final authService = Get.find<AuthService>();
        await authService.logout();
      } catch (e) {
        // Ignorar errores del logout del servidor
      }

      // Limpiar controladores
      try {
        final loggedUserController = Get.find<LoggedUserController>();
        loggedUserController.clearCookies();
        Get.delete<LoggedUserController>();
      } catch (e) {
        // Ignorar si el controlador no existe
      }

      try {
        final menuController = Get.find<MenuController>();
        menuController.changeActiveItemTo(overViewPageDisplayName);
      } catch (e) {
        // Ignorar si el controlador no existe
      }

      // Cerrar cualquier diálogo abierto
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Redirigir al login
      Get.offAllNamed(authenticationPageRoute);
    } catch (e) {
      // Si todo falla, al menos redirigir al login
      Get.offAllNamed(authenticationPageRoute);
    }
  }

  Future<void> logout() async {
    try {
      final authService = Get.find<AuthService>();
      // Solo mostrar loading si hay contexto válido
      if (Get.context != null) {
        loading(Get.context!);
      }
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
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.offAllNamed(authenticationPageRoute);
    } catch (e) {
      // Si hay error, usar el método de fuerza
      await _forceLogout();
    }
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
