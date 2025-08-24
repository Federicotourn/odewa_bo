import 'package:odewa_bo/pages/authentication/authentication.dart';
import 'package:odewa_bo/pages/companies/companies_view.dart';
import 'package:odewa_bo/pages/overview/overview.dart';
import 'package:odewa_bo/pages/requests/request_detail_view.dart';
import 'package:odewa_bo/pages/requests/requests_view.dart';
import 'package:odewa_bo/pages/users/users_view.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overViewPageRoute:
      return getPageRoute(OverviewPage());
    case authenticationPageRoute:
      return getPageRoute(const AuthenticationPage());
    case usersPageRoute:
      return getPageRoute(const UsersView());
    case companiesPageRoute:
      return getPageRoute(const CompaniesView());
    case requestsPageRoute:
      return getPageRoute(const RequestsView());
    case requestDetailPageRoute:
      return getPageRoute(RequestDetailView());
    default:
      return getPageRoute(OverviewPage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
