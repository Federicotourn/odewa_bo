// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_web_libraries_in_flutter
import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/pages/authentication/controllers/auth_controller.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final AuthController authController = Get.put(AuthController());
  final LoggedUserController loggedUserController = Get.put(
    LoggedUserController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.3),
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  "assets/logotipo-paytonic.png",
                  width: Get.width * 0.5,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: authController.emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "abc@odewa.com",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: authController.passwordController,
                obscureText: !authController.passwordIsVisible.value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.passwordIsVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        authController.passwordIsVisible.value =
                            !authController.passwordIsVisible.value;
                      });
                    },
                  ),
                  labelText: "Contraseña",
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "Contraseña",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (authController.validateEmail(
                          authController.emailController.text,
                        ) !=
                        null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Por favor, verifique sus credenciales",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final (success, message) = await authController.login();
                      if (success) {
                        final userLoaded =
                            await loggedUserController.getLoggedUser();
                        if (userLoaded &&
                            loggedUserController.user.value != null) {
                          Get.offAllNamed('/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Error al cargar los datos del usuario. Por favor, inténtelo de nuevo.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Error al iniciar sesión. Por favor, inténtelo de nuevo.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.light,
                    foregroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:
                      authController.isLoggingIn.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Ingresar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
