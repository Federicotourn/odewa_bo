import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_text.dart';

class VerticalMenuItem extends StatelessWidget {
  const VerticalMenuItem({
    super.key,
    required this.itemName,
    required this.onTap,
    this.hasWarning = false,
    this.numWarning = 0,
  });

  final String itemName;
  final VoidCallback onTap;
  final bool hasWarning;
  final int numWarning;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        value
            ? menuController.onHover(itemName)
            : menuController.onHover("not hovering");
      },
      child: Obx(
        () => Container(
          color:
              menuController.isHovering(itemName)
                  ? AppTheme.lightGray.withValues(alpha: .1)
                  : Colors.transparent,
          child: Row(
            children: [
              Visibility(
                visible:
                    menuController.isHovering(itemName) ||
                    menuController.isActive(itemName),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(width: 3, height: 72, color: AppTheme.dark),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: menuController.returnIconFor(itemName),
                    ),
                    if (!menuController.isActive(itemName))
                      Flexible(
                        child: CustomText(
                          text: itemName,
                          color:
                              menuController.isHovering(itemName)
                                  ? AppTheme.dark
                                  : AppTheme.lightGray,
                        ),
                      )
                    else
                      Flexible(
                        child: CustomText(
                          text: itemName,
                          color: AppTheme.dark,
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
