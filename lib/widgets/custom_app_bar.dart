import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: ResponsiveWidget.isSmallScreen(context),
      leading:
          (ResponsiveWidget.isSmallScreen(context))
              ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppTheme.white,
                ),
              )
              : (showBackButton != null)
              ? showBackButton!
              : null,
      title: Text(title, style: AppTheme.title),
      centerTitle: false,
      backgroundColor: AppTheme.primary,
      actions: actions,
    );
  }
}
