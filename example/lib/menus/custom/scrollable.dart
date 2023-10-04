import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/menus/custom_draggable_menu.dart';
import 'package:flutter/material.dart';

class ScrollableMenu extends StatelessWidget {
  final Type ui;
  final bool enableExpandedScroll;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;

  const ScrollableMenu({
    super.key,
    required this.ui,
    required this.enableExpandedScroll,
    required this.fastDrag,
    required this.minimizeBeforeFastDrag,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMenu(
      ui: ui,
      fastDrag: fastDrag,
      minimizeBeforeFastDrag: minimizeBeforeFastDrag,
      child: ScrollableManager(
        enableExpandedScroll: enableExpandedScroll,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 25,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) => ListTile(
            onTap: () {},
            title: Text(
              "Item ${index + 1}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
