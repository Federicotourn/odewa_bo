import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/layout.dart';
import 'package:odewa_bo/pages/404/error_page.dart';
import 'package:odewa_bo/pages/authentication/authentication.dart';
import 'package:odewa_bo/pages/companies/companies_view.dart';
import 'package:odewa_bo/pages/requests/request_detail_view.dart';
import 'package:odewa_bo/pages/requests/requests_view.dart';
import 'package:odewa_bo/pages/users/users_view.dart';
import 'package:odewa_bo/pages/clients/clients_view.dart';
import 'package:odewa_bo/pages/clients/client_detail_view.dart';
import 'package:odewa_bo/pages/overview/overview.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Rutas constantes
const rootRoute = "/home";
const overViewPageRoute = "/overview";
const usersPageRoute = "/users";
const companiesPageRoute = "/companies";
const requestsPageRoute = "/requests";
const clientsPageRoute = "/clients";
const authenticationPageRoute = "/auth";
const requestDetailPageRoute = "/request-detail";
const companyDetailPageRoute = "/company-detail";
const clientDetailPageRoute = "/client-detail";
const overviewNewPageRoute = "/overview-new";
const notFoundPageRoute = "/not-found";

// Nombres de visualización
const overViewPageDisplayName = "Dashboard";
const usersPageDisplayName = "Administradores";
const clientsPageDisplayName = "Usuarios";
const companiesPageDisplayName = "Empresas";
const requestsPageDisplayName = "Solicitudes";
const authenticationDisplayName = "Cerrar sesión";
const clientDetailPageDisplayName = "Detalle de empleado";
const requestDetailPageDisplayName = "Detalle de solicitud";
const companyDetailPageDisplayName = "Detalle de empresa";

class AppPages {
  static final routes = [
    GetPage(
      name: authenticationPageRoute,
      page: () => const AuthenticationPage(),
    ),
    GetPage(
      name: rootRoute,
      page: () => SiteLayout(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: usersPageRoute,
      page: () => const UsersView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: companiesPageRoute,
      page: () => const CompaniesView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: requestsPageRoute,
      page: () => const RequestsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: requestDetailPageRoute,
      page: () => RequestDetailView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: clientsPageRoute,
      page: () => ClientsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: clientDetailPageRoute,
      page: () => const ClientDetailView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: overviewNewPageRoute,
      page: () => OverviewPageNew(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: notFoundPageRoute, page: () => const PageNotFound()),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final loggedUserController = Get.find<LoggedUserController>();
      if (loggedUserController.user.value == null) {
        return const RouteSettings(name: authenticationPageRoute);
      }

      // Si el usuario es client e intenta acceder a companies, redirigir al overview
      if (route == companiesPageRoute && loggedUserController.isClient) {
        return const RouteSettings(name: overViewPageRoute);
      }

      return null;
    } catch (e) {
      return const RouteSettings(name: authenticationPageRoute);
    }
  }
}

class MenuItem {
  final String name;
  final String route;
  final List<String>? requiredPermissions;

  MenuItem({required this.name, required this.route, this.requiredPermissions});
}

List<MenuItem> sideMenuItems = [
  MenuItem(name: overViewPageDisplayName, route: overViewPageRoute),
  MenuItem(name: usersPageDisplayName, route: usersPageRoute),
  MenuItem(name: clientsPageDisplayName, route: clientsPageRoute),
  MenuItem(name: companiesPageDisplayName, route: companiesPageRoute),
  MenuItem(name: requestsPageDisplayName, route: requestsPageRoute),
  MenuItem(name: authenticationDisplayName, route: authenticationPageRoute),
];
