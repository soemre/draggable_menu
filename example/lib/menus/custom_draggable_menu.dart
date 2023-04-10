import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomDraggableMenu extends StatelessWidget {
  final DraggableMenuUiType? uiType;
  final bool? expand;
  final Widget? child;
  final bool? fastDrag;
  final bool? minimizeBeforeFastDrag;

  const CustomDraggableMenu({
    super.key,
    this.uiType,
    this.expand,
    this.child,
    this.fastDrag,
    this.minimizeBeforeFastDrag,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      uiType: uiType,
      expandable: expand,
      expandedHeight: MediaQuery.of(context).size.height * 0.72,
      maxHeight: MediaQuery.of(context).size.height * 0.36,
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
      child: child,
    );
  }
}
