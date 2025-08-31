import 'dart:convert';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/users/models/user_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UsersService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();

  final box = GetStorage('User');

  Future<UsersService> init() async {
    return this;
  }

  Future<(bool, List<User>)> getUsers() async {
    List<User> users = [];
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/backoffice/users');

      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var response = await _tokenValidationService.client.get(
        url,
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        List<User> userResponses = userResponseFromJson(response.body).data;
        return (true, userResponses);
      } else {
        debugPrint('Error response: ${response.statusCode} - ${response.body}');
        return (false, users);
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return (false, users);
    }
  }

  Future<(bool, String)> createUser(Map<String, dynamic> user) async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/backoffice/users');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var response = await _tokenValidationService.client.post(
        url,
        body: json.encode(user),
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_201_CREATED) {
        return (true, 'Usuario creado correctamente');
      } else {
        return Constants.handleError(response.body, response.statusCode);
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return (false, 'Error al crear el usuario');
    }
  }

  Future<(bool, String)> updateUser(User user) async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/users');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var response = await _tokenValidationService.client.put(
        url,
        body: json.encode(user.toJson()),
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Usuario actualizado correctamente');
      } else {
        return Constants.handleError(response.body, response.statusCode);
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return (false, 'Error al actualizar el usuario');
    }
  }

  Future<(bool, String)> deleteUser(String email) async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/users');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var body = {'email': email};

      var response = await _tokenValidationService.client.delete(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Usuario eliminado correctamente');
      } else {
        return Constants.handleError(response.body, response.statusCode);
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return (false, 'Error al eliminar el usuario');
    }
  }

  Future<(bool, String)> changePassword(
    String userEmail,
    String password,
  ) async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/users/change-password');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var body = {'email': userEmail, 'password': password};

      var response = await _tokenValidationService.client.put(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Contraseña cambiada correctamente');
      } else {
        return Constants.handleError(response.body, response.statusCode);
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return (false, 'Error al cambiar la contraseña');
    }
  }
}
