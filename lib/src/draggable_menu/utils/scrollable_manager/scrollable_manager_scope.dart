import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:flutter/material.dart';

class ScrollableManagerScope extends InheritedWidget {
  const ScrollableManagerScope({
    this.canExpand,
    this.status,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragStart,
    super.key,
    required Widget child,
  }) : super(child: child);

  final void Function(double globalPosition)? onDragUpdate;
  final void Function(DragEndDetails details)? onDragEnd;
  final void Function(double globalPosition)? onDragStart;
  final DraggableMenuStatus? status;
  final bool? canExpand;

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
