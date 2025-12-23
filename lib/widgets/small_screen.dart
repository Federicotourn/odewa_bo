import 'package:odewa_bo/helpers/local_navigator.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:flutter/material.dart';

class SmallScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SmallScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveWidget.isSmallScreen(context) ? 8 : 16,
      ),
      child: localNavigator(),
    );
  }
}
