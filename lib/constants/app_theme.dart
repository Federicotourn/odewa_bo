import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF9661ed);
  static const Color primaryLight = Color.fromARGB(255, 173, 135, 233);
  static const Color primaryBottom = Color(0xFF003dc4);
  static const Color primaryBottomLight = Color(0xFF50A0FF);
  static const Color onyx = Color(0xFF1C1E21);
  static const Color nearlyWhite = Color(0xFFF7F7F7);
  static const Color nearlyBlack = Color(0xFF2C2948);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF808080);
  static const Color light = Color(0xFFF4F3FF);

  static const Color light2 = Color(0xFFF7F8FC);
  static const Color lightGray = Color(0xFFA4A6B3);
  static const Color dark = Color(0xFF363740);
  static const Color active = Color(0xFF3C19C0);

  static const Color error = Color(0xFFF5222D);
  static const Color warning = Color(0xFFFAAD14);
  static const Color success = Color(0xFF52C41A);

  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.white,
  );

  static const TextStyle titleTable = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTheme.black,
  );

  static const TextStyle inputButton = TextStyle(
    fontSize: 16,
    color: AppTheme.white,
  );

  static const TextStyle titleClientDetail = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppTheme.black,
  );

  static const TextStyle subtitleClientDetail = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppTheme.black,
  );

  static const TextStyle textClientDetail = TextStyle(
    fontSize: 16,
    color: AppTheme.black,
  );
}
