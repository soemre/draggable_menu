import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class SoftModernUi extends StatelessWidget {
  final Widget? child;
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final double? radius;
  final double menuValue;

  const SoftModernUi({
    super.key,
    this.child,
    this.barItem,
    this.accentColor,
    this.color,
    this.radius,
    required this.menuValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16 * (1 - (menuValue < 0 ? 0 : menuValue))),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(radius ?? 16),
            bottom: Radius.circular((radius ?? 16) *
                (1 - (menuValue < 0 ? -menuValue : menuValue)))),
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
      ),
    );
  }
}
