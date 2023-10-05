import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

/// Extend the `CustomDraggableMenu` class to create your own Draggable Menu UIs.
///
/// Override the `buildUI` method to pass your UI.
abstract class CustomDraggableMenu {
  const CustomDraggableMenu();

  /// Configures whether the draggable menu is expandable or not.
  ///
  /// If it's not expandable, only the level parameter with the lowest height will be used as the fixed height.
  bool get expandable => true;

  /// You can listen to the Draggable Menu's current status with the `status` value and
  /// current menuValue with the `menuValue` value.
  ///
  /// The `child` value gives the child passed to the `DraggableMenu` widget.
  ///
  /// Use the `animationDuration` and the `curve` values to get Draggable Menu's current `animationDuration` and `curve`.
  Widget buildUi(
    BuildContext context,
    Widget child,
    DraggableMenuStatus status,
    int level,
    double menuValue,
    double? raw,
    double levelValue,
    Duration animationDuration,
    Curve curve,
  );
}
