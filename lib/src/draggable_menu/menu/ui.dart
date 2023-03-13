import 'package:draggable_menu/src/draggable_menu/menu/enums/status.dart';
import 'package:draggable_menu/src/draggable_menu/menu/enums/ui.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui/classic.dart';
import 'package:draggable_menu/src/draggable_menu/menu/ui/modern.dart';
import 'package:flutter/material.dart';

class DraggableMenuUi extends StatelessWidget {
  final Widget? child;
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final Radius? radius;
  final double maxHeight;
  final double minHeight;
  final DraggableMenuUiType? uiType;
  final Widget? customUi;
  final DraggableMenuStatus? status;
  final Duration? animationDuration;

  const DraggableMenuUi({
    super.key,
    this.child,
    this.barItem,
    this.color,
    this.accentColor,
    required this.maxHeight,
    required this.minHeight,
    this.radius,
    this.uiType,
    this.customUi,
    this.status,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: minHeight,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: customUi ?? _ui(),
      ),
    );
  }

  Widget _ui() {
    if (uiType == DraggableMenuUiType.modern) {
      return ModernUi(
        accentColor: accentColor,
        color: color,
        radius: radius,
        barItem: barItem,
        status: status,
        animationDuration: animationDuration,
        child: child,
      );
    }
    return ClassicUi(
      accentColor: accentColor,
      color: color,
      radius: radius,
      barItem: barItem,
      child: child,
    );
  }
}
