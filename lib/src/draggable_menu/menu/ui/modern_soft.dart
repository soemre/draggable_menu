import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class SoftModernDraggableMenu extends CustomDraggableMenu {
  /// Overrides the Default Bar Item of the UI.
  final Widget? barItem;

  /// Specifies the Bar Item color of the UI.
  final Color? accentColor;

  /// Specifies the Background color of the UI.
  final Color? color;

  /// Specifies the radius of the UI.
  final double? radius;

  const SoftModernDraggableMenu({
    this.barItem,
    this.accentColor,
    this.color,
    this.radius,
  });

  @override
  Widget buildUi(
      BuildContext context,
      Widget child,
      DraggableMenuStatus? status,
      double menuValue,
      Duration animationDuration,
      Curve curve) {
    // Do not use abs() instead of (menuValue < 0 ? 0 : menuValue)
    return Padding(
      padding: EdgeInsets.all(16 * (1 - (menuValue < 0 ? 0 : menuValue))),
      child: Material(
        animationDuration: Duration.zero,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(radius ?? 16),
            bottom: Radius.circular(
                (radius ?? 16) * (1 - (menuValue < 0 ? 0 : menuValue)))),
        color: color ?? DefaultColors.primaryBackground,
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
