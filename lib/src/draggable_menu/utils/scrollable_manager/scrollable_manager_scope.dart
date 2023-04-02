import 'package:flutter/material.dart';

class ScrollableManagerScope extends InheritedWidget {
  const ScrollableManagerScope(
      {this.onDragUpdate,
      this.onDragEnd,
      this.onDragStart,
      super.key,
      required Widget child})
      : super(child: child);

  final void Function(double globalPosition)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function(double globalPosition)? onDragStart;

  static ScrollableManagerScope of(BuildContext context) {
    final ScrollableManagerScope? result =
        context.dependOnInheritedWidgetOfExactType<ScrollableManagerScope>();
    if (result == null) throw "Result can't be null.";
    return result;
  }

  @override
  bool updateShouldNotify(ScrollableManagerScope oldWidget) {
    return true;
  }
}
