import 'package:odewa_bo/constants/controllers.dart';
import 'package:odewa_bo/routing/router.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Navigator localNavigator() => Navigator(
  key: navigationController.navigatorKey,
  initialRoute: overViewPageRoute,
  onGenerateRoute: generateRoute,
);
