import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomDraggableMenu extends StatelessWidget {
  final DraggableMenuUiType? uiType;
  final bool? expand;
  final Widget? child;

  const CustomDraggableMenu({super.key, this.uiType, this.expand, this.child});

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      uiType: uiType,
      expandable: expand,
      expandedHeight: MediaQuery.of(context).size.height * 0.72,
      maxHeight: MediaQuery.of(context).size.height * 0.36,
      child: child,
    );
  }
}
