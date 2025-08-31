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
        box.write('user', json.encode(loginResponse.user.toJson()));
        _loggedUserController.saveUserToCookie(
          loginResponse.user.toJson().toString(),
        );
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

  Future<void> logout() async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/auth/logout');

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var response = await _tokenValidationService.client.post(
        url,
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        _loggedUserController.clearUser();
        _loggedUserController.clearCookies();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
