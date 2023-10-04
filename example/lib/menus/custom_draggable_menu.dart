import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/widgets/modular_menu_example_item.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Type ui;
  final Widget child;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;
  final DraggableMenuController? controller;

  const CustomMenu({
    super.key,
    required this.child,
    required this.fastDrag,
    required this.minimizeBeforeFastDrag,
    required this.ui,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      controller: controller,
      ui: ui == ModernDraggableMenu
          ? ModernDraggableMenu(child: child)
          : ui == SoftModernDraggableMenu
              ? SoftModernDraggableMenu(child: child)
              : ui == ModularDraggableMenu
                  ? ModularDraggableMenu(
                      children: [
                        child,
                        const ModularMenuExampleItem(),
                      ],
                    )
                  : ClassicDraggableMenu(child: child),
      levels: [
        DraggableMenuLevel.ratio(ratio: 1 / 3),
        DraggableMenuLevel.ratio(ratio: 2 / 3),
        DraggableMenuLevel.ratio(ratio: 1),
      ],
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
    );
  }
}
