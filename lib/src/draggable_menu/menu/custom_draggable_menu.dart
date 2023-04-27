import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

/// Extend the `CustomDraggableMenu` class to create your own Draggable Menu UIs.
///
/// Override the `buildUI` method to pass your UI.
abstract class CustomDraggableMenu {
  const CustomDraggableMenu();

  /// You can listen to the Draggable Menu's current status from the `status` value and
  /// current menuValue from the `menuValue` value.
  ///
  /// The `child` value gives the child passed to the `DraggableMenu` widget.
  Widget buildUi(BuildContext context, Widget child,
      DraggableMenuStatus? status, double menuValue);
}
