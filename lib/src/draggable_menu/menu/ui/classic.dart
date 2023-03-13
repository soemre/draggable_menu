import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class ClassicUi extends StatelessWidget {
  final Widget? child;
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final Radius? radius;

  const ClassicUi(
      {super.key,
      this.child,
      this.barItem,
      this.accentColor,
      this.color,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: radius ?? const Radius.circular(16),
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
            if (child != null) Flexible(child: child!),
          ],
        ),
      ),
    );
  }
}
