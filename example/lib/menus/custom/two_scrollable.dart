import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import '../custom_draggable_menu.dart';

class TwoScrollableMenu extends StatelessWidget {
  final CustomDraggableMenu ui;
  final bool enableExpandedScroll;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;

  const TwoScrollableMenu({
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
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Row(
            children: [
              Flexible(
                child: ColoredBox(
                  color: Colors.indigoAccent,
                  child: ScrollableManager(
                    enableExpandedScroll: enableExpandedScroll,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 25,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          "Item ${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Flexible(
                child: ColoredBox(
                  color: Colors.indigoAccent,
                  child: ScrollableManager(
                    enableExpandedScroll: enableExpandedScroll,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 25,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          "Item ${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
