import 'package:flutter/material.dart';

class TextSelectionConfig {
  // Configuración global para hacer el texto seleccionable
  static const bool enableTextSelection = true;

  // Opciones de la barra de herramientas para texto seleccionable
  static const ToolbarOptions defaultToolbarOptions = ToolbarOptions(
    copy: true,
    selectAll: true,
    cut: false,
    paste: false,
  );

  // Estilo por defecto para texto seleccionable
  static TextStyle get defaultSelectableTextStyle => const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  // Widget helper para crear texto seleccionable fácilmente
  static Widget createSelectableText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    VoidCallback? onTap,
  }) {
    return SelectableText(
      text,
      style: style ?? defaultSelectableTextStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      toolbarOptions: defaultToolbarOptions,
      onTap: onTap,
    );
  }
}
