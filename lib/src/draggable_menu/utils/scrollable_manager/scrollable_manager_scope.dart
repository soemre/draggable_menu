import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:flutter/material.dart';

class ScrollableManagerScope extends InheritedWidget {
  /// Just an inherited widget to provied needed variables and functions to scrollable managers.
  ///
  /// Scrollable managers will look up for this widget to controll the `DraggableMenu` widget.
  const ScrollableManagerScope({
    required this.canExpand,
    required this.status,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragStart,
    super.key,
    required Widget child,
  }) : super(child: child);

  /// Handels Drag Start Events of the Draggable Menu
  final void Function(double globalPosition) onDragStart;

  /// Handels Drag Update Events of the Draggable Menu
  final void Function(double globalPosition) onDragUpdate;

  /// Handels Drag End Events of the Draggable Menu
  final void Function(DragEndDetails details) onDragEnd;

  /// Draggable Menu's Current Status
  final DraggableMenuStatus status;

  /// Does the widget have enough levels to expand
  final bool canExpand;

  static ScrollableManagerScope of(BuildContext context) {
    final ScrollableManagerScope? result =
        context.dependOnInheritedWidgetOfExactType<ScrollableManagerScope>();
    assert(result != null, "Result can't be null.");
    return result!;
  }

  @override
  bool updateShouldNotify(ScrollableManagerScope oldWidget) {
    return true;
  }
}
