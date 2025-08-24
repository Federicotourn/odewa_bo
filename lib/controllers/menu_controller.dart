import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static final MenuController instance = Get.find<MenuController>();
  var activeItem = overViewPageDisplayName.obs;
  var hoverItem = ''.obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  bool isActive(String itemName) => activeItem.value == itemName;
  bool isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case overViewPageDisplayName:
        return customIcon(Icons.dashboard_outlined, itemName);
      case usersPageDisplayName:
        return customIcon(Icons.people_alt_outlined, itemName);
      case clientsPageDisplayName:
        return customIcon(Icons.person_outline, itemName);
      case companiesPageDisplayName:
        return customIcon(Icons.business_outlined, itemName);
      case requestsPageDisplayName:
        return customIcon(Icons.request_page_outlined, itemName);
      case authenticationDisplayName:
        return customIcon(Icons.logout_outlined, itemName);

      default:
        return customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 18, color: AppTheme.white);
    return Icon(icon, size: 18, color: AppTheme.white);
  }
}
