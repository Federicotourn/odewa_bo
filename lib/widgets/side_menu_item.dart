import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:odewa_bo/widgets/horizontal_menu_item.dart';
import 'package:odewa_bo/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
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
    if (ResponsiveWidget.isCustomScreen(context)) {
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
        hasWarning: hasWarning,
        numWarning: numWarning,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
        hasWarning: hasWarning,
        numWarning: numWarning,
      );
    }
  }
}
