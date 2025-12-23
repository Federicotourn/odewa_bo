// import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:odewa_bo/widgets/large_screen.dart';
import 'package:odewa_bo/widgets/side_menu.dart';
import 'package:odewa_bo/widgets/small_screen.dart';
import 'package:flutter/material.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // final loggedUserController = Get.put(LoggedUserController());
    return Scaffold(
      key: scaffoldKey,
      drawer:
          ResponsiveWidget.isSmallScreen(context)
              ? const Drawer(child: SideMenu())
              : null,
      body: ResponsiveWidget(
        largeScreen: LargeScreen(),
        mediumScreen: LargeScreen(),
        smallScreen: SmallScreen(scaffoldKey: scaffoldKey),
      ),
    );
  }
}
