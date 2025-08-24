import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_text.dart';

class HorizontalMenuItem extends StatelessWidget {
  const HorizontalMenuItem({
    Key? key,
    required this.itemName,
    required this.onTap,
    this.hasWarning = false,
    this.numWarning = 0,
  }) : super(key: key);

  final String itemName;
  final VoidCallback onTap;
  final bool hasWarning;
  final int numWarning;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                  ? AppTheme.lightGray.withOpacity(.1)
                  : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible:
                    menuController.isHovering(itemName) ||
                    menuController.isActive(itemName),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Container(width: 6, height: 40, color: AppTheme.dark),
              ),
              SizedBox(width: width / 88),
              Padding(
                padding: const EdgeInsets.all(16),
                child: menuController.returnIconFor(itemName),
              ),
              Expanded(
                child: Row(
                  children: [
                    CustomText(
                      text: itemName,
                      color:
                          menuController.isActive(itemName)
                              ? AppTheme.dark
                              : menuController.isHovering(itemName)
                              ? AppTheme.dark
                              : AppTheme.lightGray,
                      size: menuController.isActive(itemName) ? 18 : null,
                      weight:
                          menuController.isActive(itemName)
                              ? FontWeight.bold
                              : null,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    if (hasWarning)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          // width: 20,
                          // height: 25,
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              child: CustomText(
                                text: numWarning.toString(),
                                color: AppTheme.white,
                                size: 12,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
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
