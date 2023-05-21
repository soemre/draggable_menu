import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final CustomDraggableMenu? ui;
  final Widget child;
  final bool? fastDrag;
  final bool? minimizeBeforeFastDrag;

  const CustomMenu({
    super.key,
    required this.child,
    this.fastDrag,
    this.minimizeBeforeFastDrag,
    this.ui,
  });

  @override
  Widget build(BuildContext context) {
    final double pageSize =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return DraggableMenu(
      ui: ui,
      levels: [
        DraggableMenuLevel(height: pageSize * 2 / 3),
        DraggableMenuLevel(height: pageSize),
      ],
      defaultHeight: pageSize * 1 / 3,
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
      child: child,
    );
  }
}
