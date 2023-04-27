import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class ClassicDraggableMenu extends CustomDraggableMenu {
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final double? radius;

  const ClassicDraggableMenu(
      {this.barItem, this.accentColor, this.color, this.radius});

  @override
  Widget buildUi(BuildContext context, Widget child, DraggableMenuStatus? status,
      double menuValue) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius ?? 16),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? DefaultColors.primaryBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: barItem ?? DefaultBarItem(color: accentColor),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
