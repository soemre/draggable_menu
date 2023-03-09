import 'package:draggable_menu/src/draggable_menu/menu/menu.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:flutter/material.dart';

class DraggableMenu {
  static open(
    BuildContext context, {
    Widget? child,
    Color? color,
    Color? accentColor,
  }) =>
      Navigator.maybeOf(context)?.push(
        MenuRoute(
          child: Menu(
            color: color,
            accentColor: accentColor,
            child: child,
          ),
        ),
      );
}
