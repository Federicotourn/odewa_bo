import 'dart:convert';

import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/pages/authentication/models/login_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();
  late final LoggedUserController _loggedUserController;

  final box = GetStorage('User');

  Future<AuthService> init() async {
    _loggedUserController = Get.put(LoggedUserController());
    return this;
  }

  Future<(bool, String)> login(String email, String password) async {
    try {
      final Uri url = Uri.parse(Urls.authLogin);

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      var body = json.encode({
        'email': email.trim(),
        'password': password.trim(),
      });

      var response = await _tokenValidationService.client.post(
        url,
        body: body,
        headers: headers,
      );
      if (response.statusCode == Constants.HTTP_201_CREATED) {
        LoginResponse loginResponse = loginResponseFromJson(response.body);
        box.write('token', loginResponse.token);
        final userJson = json.encode(loginResponse.user.toJson());
        box.write('user', userJson);
        _loggedUserController.saveUserToCookie(userJson);
        _loggedUserController.getLoggedUser();
        return (true, 'Inicio de sesión exitoso');
      } else {
        return Constants.handleError(response.body, response.statusCode);
      }
    } catch (e) {
      debugPrint(e.toString());
      return (false, 'Error al iniciar sesión');
    }
  }

  // Future<bool> getPersonalData() async {
  //   try {
  //     final Uri url = Uri.parse('${Urls.baseUrl}/auth/me');

  //     Map<String, String> headers = {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'ngrok-skip-browser-warning': 'true',
  //       'Authorization': 'Bearer ${box.read('token')}',
  //     };

  //     var response = await _tokenValidationService.client.get(
  //       url,
  //       headers: headers,
  //     );

  //     if (response.statusCode == Constants.HTTP_200_OK) {
  //       LoginData data = loginFromJson(response.body);
  //       box.write('user', response.body);
  //       _loggedUserController.saveUserToCookie(response.body);
  //       _loggedUserController.getLoggedUser();
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  /// Limpia completamente todos los datos de sesión
  Future<void> clearAllSessionData() async {
    try {
      // Limpiar storage
      box.remove('user');
      box.remove('token');

      // Limpiar cookies y usuario del controlador
      try {
        _loggedUserController.clearCookies();
        _loggedUserController.clearUser();
        _loggedUserController.user.value = null;
      } catch (e) {
        debugPrint('Error clearing logged user controller: $e');
      }

      // Limpiar controladores
      try {
        Get.delete<LoggedUserController>(force: true);
      } catch (e) {
        // Ignorar si no existe
      }

      // Cerrar cualquier diálogo abierto
      while (Get.isDialogOpen == true) {
        Get.back();
      }

      // Cerrar cualquier snackbar abierto
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }
    } catch (e) {
      debugPrint('Error clearing session data: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Intentar hacer logout en el servidor
      final Uri url = Uri.parse('${Urls.baseUrl}/auth/logout');
      final token = box.read('token');

      if (token != null) {
        Map<String, String> headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'Authorization': 'Bearer $token',
        };

        try {
          await _tokenValidationService.client.post(url, headers: headers);
          // No importa el resultado, siempre limpiamos localmente
        } catch (e) {
          // Ignorar errores del servidor, siempre limpiamos localmente
          debugPrint('Error calling logout endpoint: $e');
        }
      }

      // Siempre limpiar datos locales, incluso si el logout del servidor falla
      await clearAllSessionData();
    } catch (e) {
      debugPrint('Error in logout: $e');
      // Asegurar limpieza incluso si hay errores
      await clearAllSessionData();
    }
  }
}
