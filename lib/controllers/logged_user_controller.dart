import 'dart:convert';

import 'package:odewa_bo/pages/authentication/models/login_model.dart';
import 'package:odewa_bo/services/logged_user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:html' as html;

class LoggedUserController extends GetxController {
  final Rxn<OdewaUser> user = Rxn<OdewaUser>();
  final RxBool isLoading = true.obs;
  final LoggedUserService _loggedUserService = Get.find<LoggedUserService>();

  final box = GetStorage('User');

  void saveTokenToCookie(String token) {
    html.document.cookie = 'token=$token; path=/;';
  }

  void saveUserToCookie(String userJson) {
    html.document.cookie = 'user=$userJson; path=/;';
  }

  String? getCookie(String name) {
    final cookies = html.document.cookie?.split(';') ?? [];
    for (final cookie in cookies) {
      final parts = cookie.split('=');
      if (parts[0].trim() == name) {
        return parts.sublist(1).join('=');
      }
    }
    return null;
  }

  void clearCookies() {
    html.document.cookie =
        'token=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/;';
    html.document.cookie =
        'user=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/;';
  }

  @override
  void onInit() {
    super.onInit();
    if (box.hasData('token') || getCookie('token') != null) {
      getLoggedUser();
    } else {
      isLoading.value = false;
    }
  }

  Future<bool> getLoggedUser() async {
    try {
      isLoading.value = true;
      final userData = box.read('user') ?? getCookie('user');
      final token = box.read('token') ?? getCookie('token');

      if (userData != null && token != null) {
        if (userData is String) {
          final loginData = OdewaUser.fromJson(json.decode(userData));
          user.value = loginData;
        } else {
          user.value = null;
          return false;
        }
        debugPrint('User loaded: ${user.value?.firstName}');
        return user.value != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error getting logged user: $e');
      user.value = null;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearUser() {
    user.value = null;
    box.remove('user');
    box.remove('token');
    clearCookies();
  }

  List<String> get userPermissions {
    return [];
  }

  bool hasPermission(String permission) {
    return userPermissions.contains(permission.toUpperCase());
  }
}
