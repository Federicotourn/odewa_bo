import 'dart:convert';

class Constants {
  static const String cookieName = "jwt";

  String ERROR_GENERIC = 'Error al procesar la solicitud';
  String ERROR_AUTHENTICATION = 'Error al autenticar el usuario';
  String ERROR_PERMISSIONS = 'Error al verificar los permisos';
  String ERROR_VALIDATION = 'Error al validar los datos';
  String ERROR_SERVER = 'Error en el servidor';
  String ERROR_CONNECTION = 'Error al conectar con el servidor';
  String ERROR_DUPLICATE_RECORD = 'Error al registrar el usuario';

  static const int HTTP_200_OK = 200;
  static const int HTTP_201_CREATED = 201;
  static const int HTTP_202_ACCEPTED = 202;
  static const int HTTP_204_NO_CONTENT = 204;
  static const int HTTP_400_BAD_REQUEST = 400;
  static const int HTTP_401_UNAUTHORIZED = 401;
  static const int HTTP_403_FORBIDDEN = 403;
  static const int HTTP_404_NOT_FOUND = 404;
  static const int HTTP_500_INTERNAL_SERVER_ERROR = 500;

  static const int TAKE_LIMIT = 25;

  static (bool, String) handleError(dynamic body, int statusCode) {
    if (body != null && body != '') {
      try {
        String jsonResponse = body;
        String? message = jsonDecode(jsonResponse)['message'];
        if (message != null) {
          return (false, message);
        }
      } catch (e) {
        return (false, body);
      }
    }

    switch (statusCode) {
      case HTTP_400_BAD_REQUEST:
        return (false, 'Error al validar los datos');
      case HTTP_401_UNAUTHORIZED:
        return (false, 'Error al autenticar el usuario');
      case HTTP_403_FORBIDDEN:
        return (false, 'Error al conectar con el servidor');
      case HTTP_404_NOT_FOUND:
        return (false, 'Error al conectar con el servidor');
      case HTTP_500_INTERNAL_SERVER_ERROR:
        return (false, 'Error en el servidor');
      default:
        return (false, 'Error al procesar la solicitud');
    }
  }
}
