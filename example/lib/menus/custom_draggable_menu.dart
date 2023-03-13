import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';

class CustomDraggableMenu extends StatelessWidget {
  final DraggableMenuUiType? uiType;
  final bool? maximize;

  const CustomDraggableMenu({super.key, this.uiType, this.maximize});

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      uiType: uiType,
      maximize: maximize,
      maximizedHeight: MediaQuery.of(context).size.height * 0.72,
    );
  }
}
