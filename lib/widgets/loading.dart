import 'package:odewa_bo/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void loading(
  BuildContext context, {
  bool barrierDismissible = false,
  double size = 60,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: AppTheme.primary,
              secondRingColor: AppTheme.primaryLight,
              thirdRingColor: AppTheme.primary,
              size: size,
            ),
          ),
        ),
  );
}
