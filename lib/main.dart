import 'dart:ui';

import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/controllers/menu_controller.dart' as app;
import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/layout.dart';
import 'package:odewa_bo/pages/404/error_page.dart';
import 'package:odewa_bo/pages/authentication/authentication.dart';
import 'package:odewa_bo/pages/authentication/services/auth_service.dart';
import 'package:odewa_bo/pages/companies/services/company_service.dart';
import 'package:odewa_bo/pages/requests/services/request_service.dart';
import 'package:odewa_bo/pages/users/services/users_service.dart';

// Legacy services (to be removed)
import 'package:odewa_bo/pages/overview/services/overview_service.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:odewa_bo/services/logged_user_service.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: authenticationPageRoute,
      unknownRoute: GetPage(
        name: notFoundPageRoute,
        page: () => const PageNotFound(),
      ),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      title: "Odewa Backoffice",
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.light,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.indigo,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES')],
    );
  }
}

Future<void> initialConfig() async {
  await GetStorage.init('User');
  await Get.putAsync(() => TokenValidationService().init());
  await Get.putAsync(() => LoggedUserService().init());

  // Core Odewa services
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => UsersService().init());
  Get.put(CompanyService());
  Get.put(RequestService());

  await Get.putAsync(() => OverviewService().init());

  // Controllers
  Get.put(app.MenuController());
  Get.put(NavigationController());
  Get.put(LoggedUserController());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
