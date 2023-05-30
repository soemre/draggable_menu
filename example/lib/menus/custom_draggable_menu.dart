import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final CustomDraggableMenu? ui;
  final Widget child;
  final bool? fastDrag;
  final bool? minimizeBeforeFastDrag;
  final DraggableMenuController? controller;

  const CustomMenu({
    super.key,
    required this.child,
    this.fastDrag,
    this.minimizeBeforeFastDrag,
    this.ui,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      controller: controller,
      ui: ui,
      levels: [
        DraggableMenuLevel.ratio(ratio: 1 / 3),
        DraggableMenuLevel.ratio(ratio: 2 / 3),
        DraggableMenuLevel.ratio(ratio: 1),
      ],
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
      child: child,
    );
  }
}