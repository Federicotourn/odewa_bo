import 'package:odewa_bo/pages/authentication/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final TextEditingController emailController = TextEditingController(
    text: 'admin@odewa.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'admin123',
  );
  RxBool isLoggingIn = false.obs;
  RxBool passwordIsVisible = false.obs;

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'El correo electrónico no puede estar vacío';
    } else if (!value.contains(
      RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ),
    )) {
      return 'Ingrese una dirección de correo electrónico correcta';
    }
    return null;
  }

  Future<(bool, String)> login() async {
    isLoggingIn.value = true;
    final (success, message) = await authService.login(
      emailController.text,
      passwordController.text,
    );
    isLoggingIn.value = false;
    return (success, message);
  }
}
