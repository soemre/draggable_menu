import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class DraggableMenuUi extends StatelessWidget {
  final Widget? child;
  final Widget? barItem;
  final Color? accentColor;
  final Color? color;
  final double maxHeight;
  final double minHeight;
  final Radius? radius;
  final Widget? customUi;

  const DraggableMenuUi({
    super.key,
    this.child,
    this.barItem,
    this.color,
    this.accentColor,
    required this.maxHeight,
    required this.minHeight,
    this.radius,
    this.customUi,
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
        child: customUi ??
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: radius ?? const Radius.circular(16),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color ?? DefaultColors.primaryBackground,
                ),
                child: Column(
                  children: [
                    Center(
                      child: barItem ?? DefaultBarItem(color: accentColor),
                    ),
                    if (child != null) Expanded(child: child!),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
