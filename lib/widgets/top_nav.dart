import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_text.dart';

AppBar topNavigationBar(
  BuildContext context,
  GlobalKey<ScaffoldState> key,
  LoggedUserController loggedUserController,
) => AppBar(
  automaticallyImplyLeading: ResponsiveWidget.isSmallScreen(context),
  leading:
      ResponsiveWidget.isSmallScreen(context)
          ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              key.currentState!.openDrawer();
            },
          )
          : null,
  title: Row(
    children: [
      Visibility(
        visible: !ResponsiveWidget.isSmallScreen(context),
        child: const CustomText(
          text: "Panel de administración: Finza",
          color: AppTheme.primary,
          size: 20,
          weight: FontWeight.bold,
        ),
      ),
      Expanded(child: Container()),
      const SizedBox(width: 24),
      if (!ResponsiveWidget.isSmallScreen(context))
        Obx(
          () => CustomText(
            text: loggedUserController.user.value?.firstName ?? "Usuario",
            color: AppTheme.primary,
          ),
        ),
      const SizedBox(width: 16),
      CircleAvatar(
        radius: 20,
        backgroundColor: AppTheme.primary,
        child: Icon(Icons.person, color: AppTheme.white, size: 30),
      ),
    ],
  ),
  iconTheme: IconThemeData(color: AppTheme.dark),
  elevation: 0,
  backgroundColor: Colors.transparent,
);
