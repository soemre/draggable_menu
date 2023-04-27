import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final CustomDraggableMenu? customUi;
  final bool? expand;
  final Widget child;
  final bool? fastDrag;
  final bool? minimizeBeforeFastDrag;

  const CustomMenu({
    super.key,
    this.expand,
    required this.child,
    this.fastDrag,
    this.minimizeBeforeFastDrag,
    this.customUi,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      customUi: customUi,
      expandable: expand,
      expandedHeight: MediaQuery.of(context).size.height * 0.72,
      maxHeight: MediaQuery.of(context).size.height * 0.36,
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
      child: child,
    );
  }
}
