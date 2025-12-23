import 'package:flutter/material.dart';

/// Helper para encontrar el Scaffold padre que contiene el drawer
class ScaffoldHelper {
  /// Encuentra el Scaffold padre que tiene el drawer
  static ScaffoldState? findParentScaffold(BuildContext context) {
    ScaffoldState? scaffoldState;

    // Buscar el Scaffold padre navegando hacia arriba en el árbol de widgets
    context.visitAncestorElements((element) {
      if (element.widget is Scaffold) {
        final scaffold = (element.widget as Scaffold);
        if (scaffold.drawer != null) {
          // Intentar obtener el ScaffoldState del elemento actual
          final state = element.findAncestorStateOfType<ScaffoldState>();
          if (state != null) {
            scaffoldState = state;
            return false; // Detener la búsqueda
          }
        }
      }
      return true; // Continuar buscando
    });

    // Si no encontramos uno con drawer, buscar cualquier Scaffold padre
    if (scaffoldState == null) {
      scaffoldState = context.findAncestorStateOfType<ScaffoldState>();
    }

    return scaffoldState;
  }

  /// Abre el drawer del Scaffold padre
  static void openParentDrawer(BuildContext context) {
    final scaffoldState = findParentScaffold(context);
    if (scaffoldState != null && scaffoldState.mounted) {
      scaffoldState.openDrawer();
    }
  }
}
